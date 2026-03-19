import OSLog

/// Logger를 NSCache에 저장하기 위한 Wrapper 클래스
/// Logger는 struct이므로 class로 감싸야 NSCache에 저장 가능
private final class LoggerBox {
    let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }
}

/// Logger 인스턴스를 캐싱하여 재사용하는 저장소
/// NSCache를 사용하여 메모리 압박 시 자동으로 해제되며, Thread-safe하게 동작
final class LoggerStorage {
    static let shared = LoggerStorage()

    /// 캐싱된 Logger 인스턴스들
    /// NSCache는 메모리 부족 시 자동으로 오래된 항목을 제거
    private let cache = NSCache<NSString, LoggerBox>()

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
        let key = "\(subsystem).\(category)" as NSString

        // 캐시에서 확인
        if let box = cache.object(forKey: key) {
            return box.logger
        }

        // 없으면 새로 생성 (NSCache는 thread-safe)
        let newLogger = Logger(subsystem: subsystem, category: category)
        let box = LoggerBox(logger: newLogger)
        cache.setObject(box, forKey: key)
        return newLogger
    }
}
