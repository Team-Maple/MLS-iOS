import OSLog

public protocol Loggable {}

public extension Loggable {
    /// 모듈 이름을 자동으로 추출
    /// - Returns: 타입이 정의된 모듈 이름 (예: "AuthFeature", "BookmarkFeature")
    static var subsystem: String {
        let fullName = String(reflecting: Self.self)
        // "AuthFeature.LoginViewModel" -> "AuthFeature"
        return fullName.components(separatedBy: ".").first ?? "Unknown"
    }

    /// 타입 이름을 카테고리로 사용
    /// - Returns: 타입 이름 (예: "LoginViewModel", "BookmarkManager")
    static var category: String {
        String(describing: Self.self)
    }

    /// 타입별로 캐싱된 Logger 인스턴스
    private static var logger: Logger {
        LoggerStorage.logger(subsystem: subsystem, category: category)
    }

    /// 디버그 로그 (Debug 빌드에서만 출력)
    /// - Parameter message: 로그 메시지
    func logDebug(_ message: String) {
        #if DEBUG
        Self.logger.debug("\(message)")
        #endif
    }

    /// 정보성 로그
    /// - Parameter message: 로그 메시지
    func logInfo(_ message: String) {
        Self.logger.notice("\(message)")
    }

    /// 경고 로그 (비정상적이지만 처리 가능한 상황)
    /// - Parameter message: 로그 메시지
    func logWarning(_ message: String) {
        Self.logger.warning("\(message)")
    }

    /// 에러 로그
    /// - Parameter message: 로그 메시지
    func logError(_ message: String) {
        Self.logger.error("\(message)")
    }

    /// 치명적 에러 로그 (앱 크래시 직전 상황)
    /// - Parameter message: 로그 메시지
    func logCritical(_ message: String) {
        Self.logger.critical("\(message)")
    }
}
