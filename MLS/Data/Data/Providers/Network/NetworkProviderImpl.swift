import Foundation

import DomainInterface

import RxSwift

public final class NetworkProviderImpl: NetworkProvider {

    private let session: URLSession

    private let retryAttempt: Int = 2

    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }

    public func requestData<T: Responsable & Requestable>(endPoint: T, interceptor: Interceptor?) -> Observable<T.Response> {
        return Observable.create { [weak self] observer in
            print("🚀 requestData: 요청 시작 - \(endPoint)")

            self?.sendRequest(endPoint: endPoint, interceptor: interceptor, completion: { result in

                switch result {
                case .success(let data):
                    print("✅ requestData: 응답 수신")

                    if let data = data {
                        print("📦 requestData: 응답 데이터 있음 - \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")
                        do {
                            let decoded = try JSONDecoder().decode(APIDefaultResponseDTO<T.Response>.self, from: data)
                            print("🎯 requestData: 디코딩 성공 - \(decoded)")
                            observer.onNext(decoded.data!)
                            observer.onCompleted()
                        } catch {
                            print("❌ requestData: 디코딩 실패 - \(error)")
                            observer.onError(NetworkError.decodeError(error))
                        }
                    } else {
                        print("⚠️ requestData: 응답 데이터 없음")
                        observer.onError(NetworkError.noData)
                    }

                case .failure(let error):
                    print("🔥 requestData: 네트워크 실패 - \(error)")
                    observer.onError(error)
                }
            })

            return Disposables.create()
        }
        .retry(when: { (errors: Observable<Error>) in
            errors
                .enumerated()
                .flatMap { attempt, error -> Observable<Void> in
                    print("🔁 requestData: 재시도 \(attempt + 1)회 - 에러: \(error)")
                    if attempt < self.retryAttempt, let networkError = error as? NetworkError, networkError == .retry {
                        return Observable.just(())
                    } else {
                        return Observable.error(error)
                    }
                }
        })
    }

    public func requestData(endPoint: Requestable, interceptor: Interceptor?) -> Completable {
        return Completable.create { [weak self] completable in
            self?.sendRequest(endPoint: endPoint, interceptor: interceptor, completion: { result in
                switch result {
                case .success(let data):
                    if data != nil {
                        completable(.completed)
                    } else {
                        completable(.error(NetworkError.noData))
                    }
                case .failure(let error):
                    completable(.error(error))
                }
            })
            return Disposables.create()
        }
        .retry(when: { (errors: Observable<Error>) in
            errors
                .enumerated()
                .flatMap { attempt, error -> Observable<Void> in
                    if attempt < self.retryAttempt, let networkError = error as? NetworkError, networkError == .retry {
                        return Observable.just(())
                    } else {
                        return Observable.error(error)
                    }
                }
        })
    }
}

private extension NetworkProviderImpl {
    /// 엔드 포인트를 이용하여 요청을 보내기 위한 함수
    /// - Parameters:
    ///   - endPoint: 요청을 위한 엔드포인트 객체
    ///   - completion: 응답 결과
    func sendRequest<T: Requestable>(endPoint: T, interceptor: Interceptor?, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        do {
            var request = try endPoint.getUrlRequest()
            if let interceptor = interceptor { request = interceptor.adapt(request) }
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                guard let self else {
                    completion(.failure(.providerDeallocated))
                    return
                }
                let taskResult = checkValidation(data: data, response: response, error: error, interceptor: interceptor)
                switch taskResult {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            task.resume()
        } catch {
            completion(.failure(NetworkError.urlRequest(error)))
        }
    }

    ///  통신간의 유효성 검사를 위한 함수
    /// - Parameters:
    ///   - data: 통신 결과로 돌려받은 데이터
    ///   - response: 상태코드를 포함한 통신 응답
    ///   - error: 통신간에 발생한 에러
    /// - Returns: 유효성검사 결과에 따른 데이터와 에러
    func checkValidation(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        interceptor: Interceptor?
    ) -> Result<Data?, NetworkError> {

        // 1️⃣ 네트워크 레벨 에러 먼저 체크
        if let error {
            if let urlError = error as? URLError, urlError.code == .unsupportedURL {
                return .failure(.urlRequest(error))
            }
            return .failure(.network(error))
        }

        // 2️⃣ HTTP 응답 객체 확인
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.httpError)
        }

        // 3️⃣ 상태 코드 기반 검사
        guard (200 ... 299).contains(httpResponse.statusCode) else {
            // ❗️여기서만 인터셉터 개입
            if let interceptor = interceptor,
               interceptor.retry(data: data, response: response, error: error) {
                return .failure(.retry)
            }

            let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown"
            return .failure(.statusError(httpResponse.statusCode, errorMessage))
        }

        // ✅ 성공 응답
        return .success(data)
    }
}
