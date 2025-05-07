import Foundation

import DomainInterface

import RxSwift

public final class NetworkProviderImpl: NetworkProvider {

    private let session: URLSession

    public init() {
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = session
    }

    public func requestData<T: Responsable & Requestable>(endPoint: T, interceptor: Interceptor?) -> Observable<T.Response> {
        return Observable.create { [weak self] observer in
            self?.sendRequest(endPoint: endPoint, completion: { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        do {
                            let decoded = try JSONDecoder().decode(T.Response.self, from: data)
                            observer.onNext(decoded)
                            observer.onCompleted()
                        } catch {
                            observer.onError(NetworkError.decodeError(error))
                        }
                    } else {
                        observer.onError(NetworkError.noData)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }

    public func requestData(endPoint: Requestable, interceptor: Interceptor?) -> Completable {
        return Completable.create { [weak self] completable in
            self?.sendRequest(endPoint: endPoint, completion: { result in
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
    }
}

private extension NetworkProviderImpl {
    /// 엔드 포인트를 이용하여 요청을 보내기 위한 함수
    /// - Parameters:
    ///   - endPoint: 요청을 위한 엔드포인트 객체
    ///   - completion: 응답 결과
    func sendRequest<T: Requestable>(endPoint: T, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        do {
            let request = try endPoint.getUrlRequest()

            let task = session.dataTask(with: request) { [weak self] data, response, error in
                guard let self else {
                    completion(.failure(.providerDeallocated))
                    return
                }
                let taskResult = checkValidation(data: data, response: response, error: error)
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
    func checkValidation(data: Data?, response: URLResponse?, error: Error?) -> Result<Data?, NetworkError> {
        if let error {
            if let urlError = error as? URLError, urlError.code == .unsupportedURL {
                return .failure(NetworkError.urlRequest(error))
            }
            return .failure(NetworkError.network(error))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkError.httpError)
        }

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown"
            return .failure(NetworkError.statusError(httpResponse.statusCode, errorMessage))
        }

        return .success(data)
    }
}
