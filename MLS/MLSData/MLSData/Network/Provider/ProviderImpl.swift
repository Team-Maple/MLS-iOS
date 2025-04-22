import Foundation
import os

import RxSwift

final class ProviderImpl: Provider {
    private let subsystem = "com.donggle.MLS"

    private let session: URLSession
    private let disposeBag = DisposeBag()

    init() {
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = session
    }

    func requestData<T: Responsable & Requestable>(endPoint: T, interceptor: Interceptor?) -> Observable<T.Response> {
        return Observable.create { [weak self] observer in
            guard let self else {
                observer.onError(NetworkError.providerDeallocated)
                return Disposables.create()
            }

            do {
                var request = try endPoint.getUrlRequest()

                let task = session.dataTask(with: request) { data, response, error in

                    let taskResult = self.checkValidation(data: data, response: response, error: error)
                    switch taskResult {
                    case .success(let data):
                        
                        guard let data else {
                            observer.onError(NetworkError.noData)
                            return
                        }
                        
                        do {
                            let decoded = try JSONDecoder().decode(T.Response.self, from: data)
                            observer.onNext(decoded)
                            observer.onCompleted()
                        } catch {
                            observer.onError(NetworkError.decodeError(error))
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                
                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            } catch {
                observer.onError(NetworkError.urlRequest(error))
                return Disposables.create()
            }
        }
    }

    func requestData(endPoint: Requestable, interceptor: Interceptor?) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                completable(.error(NetworkError.providerDeallocated))
                return Disposables.create()
            }

            do {
                var request = try endPoint.getUrlRequest()

                let task = session.dataTask(with: request) { data, response, error in

                    let taskResult = self.checkValidation(data: data, response: response, error: error)
                    
                    switch taskResult {
                    case .success:
                        completable(.completed)
                    case .failure(let error):
                        completable(.error(error))
                    }
                }

                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            } catch {
                completable(.error(NetworkError.urlRequest(error)))
                return Disposables.create()
            }
        }
    }
    
    func sendRequest() -> Completable {
        return Completable.create { completable in
            return Disposables.create()
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
