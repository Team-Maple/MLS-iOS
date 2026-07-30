import Foundation

import RxSwift

public final class NetworkProviderImpl: NetworkProvider, Loggable {

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
            self?.logDebug("Core requestData: 요청 시작 - \(endPoint)")

            self?.sendRequest(endPoint: endPoint, interceptor: interceptor, completion: { result in

                switch result {
                case .success(let data):
                    self?.logDebug("Core requestData: 응답 수신")

                    if let data = data {
                        self?.logDebug("Core requestData: 응답 데이터 있음 - \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")
                        do {
                            let decoded = try JSONDecoder().decode(APIDefaultResponseDTO<T.Response>.self, from: data)
                            self?.logDebug("Core requestData: 디코딩 성공 - \(decoded)")
                            if let decodedData = decoded.data {
                                observer.onNext(decodedData)
                            } else {
                                if T.Response.self == EmptyResponseDTO.self {
                                    observer.onNext(EmptyResponseDTO() as! T.Response)
                                } else {
                                    observer.onError(NetworkError.invalidResponse)
                                }
                            }
                            observer.onCompleted()
                        } catch {
                            self?.logError("Core requestData: 디코딩 실패 - \(error)")
                            observer.onError(NetworkError.decodeError(error))
                        }
                    } else {
                        self?.logWarning("Core requestData: 응답 데이터 없음")
                        observer.onError(NetworkError.noData)
                    }

                case .failure(let error):
                    self?.logError("🔥 requestData: 네트워크 실패 - \(error)")
                    observer.onError(error)
                }
            })

            return Disposables.create()
        }
        .retry(when: { (errors: Observable<Error>) in
            errors
                .enumerated()
                .flatMap { attempt, error -> Observable<Void> in
                    self.logWarning("🔁 requestData: 재시도 \(attempt + 1)회 - 에러: \(error)")
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
                    logError("API 통신에러 \(error)")
                }
            }
            task.resume()
        } catch {
            completion(.failure(NetworkError.urlRequest(error)))
        }
    }

    func checkValidation(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        interceptor: Interceptor?
    ) -> Result<Data?, NetworkError> {

        if let error {
            if let urlError = error as? URLError, urlError.code == .unsupportedURL {
                return .failure(.urlRequest(error))
            }
            return .failure(.network(error))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.httpError)
        }

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            if let interceptor = interceptor,
               interceptor.retry(data: data, response: response, error: error) {
                return .failure(.retry)
            }

            let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown"
            return .failure(.statusError(httpResponse.statusCode, errorMessage))
        }

        return .success(data)
    }
}
