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

                    if let error {
                        observer.onError(NetworkError.network(error))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        observer.onError(NetworkError.httpError)
                        return
                    }

                    guard (200 ... 299).contains(httpResponse.statusCode) else {
                        let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown"
                        observer.onError(NetworkError.statusError(httpResponse.statusCode, errorMessage))
                        return
                    }

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

                if let interceptor {
                    request = try interceptor.adapt(request)
                }

                let task = session.dataTask(with: request) { data, response, error in

                    if let error {
                        completable(.error(error))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        completable(.error(NetworkError.invalidResponse))
                        return
                    }

                    guard (200 ... 299).contains(httpResponse.statusCode) else {
                        let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown"
                        completable(.error(NetworkError.statusError(httpResponse.statusCode, errorMessage)))
                        return
                    }

                    completable(.completed)
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
}
