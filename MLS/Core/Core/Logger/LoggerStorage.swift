import OSLog

/// Logger 인스턴스를 캐싱하여 재사용하는 저장소
/// Thread-safe하게 동작하며, 같은 subsystem+category 조합은 하나의 Logger만 생성
final class LoggerStorage {
    static let shared = LoggerStorage()

    /// 캐싱된 Logger 인스턴스들 [subsystem+category: Logger]
    private var loggers: [String: Logger] = [:]

    /// 동시성 제어를 위한 큐
    private let queue = DispatchQueue(label: "com.mls.core.loggerStorage", attributes: .concurrent)

    private init() {}

    /// Logger 인스턴스를 가져오거나 생성
    /// - Parameters:
    ///   - subsystem: 모듈 이름 (예: "AuthFeature")
    ///   - category: 카테고리 이름 (예: "LoginViewModel")
    /// - Returns: 캐싱되거나 새로 생성된 Logger 인스턴스
    static func logger(subsystem: String, category: String) -> Logger {
        shared.getOrCreateLogger(subsystem: subsystem, category: category)
    }

    private func getOrCreateLogger(subsystem: String, category: String) -> Logger {
        let key = "\(subsystem).\(category)"

        // 1. 먼저 concurrent 읽기 시도 (여러 스레드가 동시에 읽을 수 있음)
        let existingLogger = queue.sync {
            loggers[key]
        }

        if let existingLogger = existingLogger {
            return existingLogger
        }

        // 2. 없으면 barrier로 쓰기 (다른 모든 작업 차단)
        return queue.sync(flags: .barrier) {
            // Double-checked locking: 다른 스레드가 이미 생성했을 수 있음
            if let logger = loggers[key] {
                return logger
            }

            let newLogger = Logger(subsystem: subsystem, category: category)
            loggers[key] = newLogger
            return newLogger
        }
    }
}
