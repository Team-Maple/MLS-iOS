import Foundation
import os

import RxSwift

final class ProviderImpl: Provider {
    private let subsystem = "com.donggle.MLS"
    private lazy var debugLog = OSLog(subsystem: subsystem, category: "debug")
    private lazy var networkLog = OSLog(subsystem: subsystem, category: "network")
    private lazy var errorLog = OSLog(subsystem: subsystem, category: "error")

    private let session: URLSession
    private let disposeBag = DisposeBag()

    init() {
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = session
    }

    func requestData<T: Decodable>(endPoint: EndPoint, interceptor: Interceptor?) -> Observable<T> {
        return Observable.create { [weak self] observer in
            guard let self else {
                os_log(.error, log: self?.errorLog ?? .default, "Provider deallocated")
                return Disposables.create()
            }

            do {
                var request = try endPoint.getUrlRequest()

                if let interceptor {
                    request = try interceptor.adapt(request)
                    os_log(.debug, log: debugLog, "Interceptor adapted request: Headers=%{public}@", "\(request.allHTTPHeaderFields ?? [:])")
                }

                os_log(.debug, log: debugLog,
                       "Request: URL=%{public}@, Method=%{public}@, Headers=%{public}@, Time=%{public}@",
                       request.url?.absoluteString ?? "N/A",
                       request.httpMethod ?? "N/A",
                       "\(request.allHTTPHeaderFields ?? [:])",
                       "\(Date())")

                let task = session.dataTask(with: request) { [weak self] data, response, error in
                    guard let self else { return }

                    os_log(.info, log: networkLog,
                           "Response: URL=%{public}@, Time=%{public}@",
                           request.url?.absoluteString ?? "N/A",
                           "\(Date())")

                    if let error {
                        os_log(.error, log: errorLog, "Network error: %{public}@", error.localizedDescription)
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        os_log(.error, log: errorLog, "Invalid response")
                        return
                    }

                    guard (200 ... 299).contains(httpResponse.statusCode) else {
                        let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown"
                        os_log(.error, log: errorLog, "HTTP error: Code=%d, Message=%{public}@", httpResponse.statusCode, errorMessage)
                        return
                    }

                    guard let data else {
                        os_log(.error, log: errorLog, "No data received")
                        return
                    }

                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        os_log(.debug, log: debugLog, "Decoded response successfully")
                        observer.onNext(decoded)
                        observer.onCompleted()
                    } catch {
                        os_log(.error, log: errorLog, "Decode error: %{public}@", error.localizedDescription)
                    }
                }

                task.resume()

                return Disposables.create {
                    task.cancel()
                    os_log(.debug, log: self.debugLog, "Request cancelled: URL=%{public}@", request.url?.absoluteString ?? "N/A")
                }
            } catch {
                os_log(.error, log: self.errorLog, "URLRequest error: %{public}@", error.localizedDescription)
                return Disposables.create()
            }
        }
    }

    func requestData(endPoint: EndPoint, interceptor: Interceptor?) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                os_log(.error, log: self?.errorLog ?? .default, "Provider deallocated")
                completable(.error(NetworkError.providerDeallocated))
                return Disposables.create()
            }

            do {
                var request = try endPoint.getUrlRequest()

                if let interceptor {
                    request = try interceptor.adapt(request)
                    os_log(.debug, log: debugLog, "Interceptor adapted request: Headers=%{public}@", "\(request.allHTTPHeaderFields ?? [:])")
                }

                os_log(
                    .debug,
                    log: debugLog,
                    "Request: URL=%{public}@, Method=%{public}@, Headers=%{public}@, Time=%{public}@",
                    request.url?.absoluteString ?? "N/A",
                    request.httpMethod ?? "N/A",
                    "\(request.allHTTPHeaderFields ?? [:])",
                    "\(Date())"
                )

                let task = session.dataTask(with: request) { [weak self] data, response, error in
                    guard let self else { return }

                    os_log(.info, log: networkLog, "Response: URL=%{public}@, Time=%{public}@", request.url?.absoluteString ?? "N/A", "\(Date())")

                    if let error {
                        os_log(.error, log: errorLog, "Network error: %{public}@", error.localizedDescription)
                        completable(.error(error))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        os_log(.error, log: errorLog, "Invalid response")
                        completable(.error(NetworkError.invalidResponse))
                        return
                    }

                    guard (200 ... 299).contains(httpResponse.statusCode) else {
                        let errorMessage = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Unknown"
                        os_log(.error, log: errorLog, "HTTP error: Code=%d, Message=%{public}@", httpResponse.statusCode, errorMessage)
                        if let error = error {
                            completable(.error(error))
                        }
                        return
                    }

                    os_log(.debug, log: debugLog, "Request completed successfully")
                    completable(.completed)
                }

                task.resume()

                return Disposables.create {
                    task.cancel()
                    os_log(.debug, log: self.debugLog, "Request cancelled: URL=%{public}@", request.url?.absoluteString ?? "N/A")
                }
            } catch {
                os_log(.error, log: self.errorLog, "URLRequest error: %{public}@", error.localizedDescription)
                completable(.error(NetworkError.urlRequest(error)))
                return Disposables.create()
            }
        }
    }
}

extension ProviderImpl {
    enum NetworkError: Error {
        case providerDeallocated
        case urlRequest(Error)
        case network(Error)
        case invalidResponse
        case noData
        case decodeError(Error)
        case httpError(Int, String?)
        case retryError(Error)
    }
}
