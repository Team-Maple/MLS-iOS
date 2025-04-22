import Foundation
import os

import RxSwift

public final class ProviderImpl: Provider {
    
    private let session: URLSession
    private let disposeBag = DisposeBag()

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
                    if let data = data {
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

private extension ProviderImpl {
    func sendRequest<T: Requestable>(endPoint: T, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        do {
            var request = try endPoint.getUrlRequest()
            
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
    
    func checkValidation(data: Data?, response: URLResponse?, error: Error?) -> Result<Data?, NetworkError> {
        if let error {
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
