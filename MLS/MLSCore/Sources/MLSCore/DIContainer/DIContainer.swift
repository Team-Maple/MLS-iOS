import Foundation

/// 의존성 주입을 위한 컨테이너
/// NSRecursiveLock을 사용하여 Thread-safe하고 재진입 가능하게 동작
/// 싱글톤 인스턴스를 캐싱하여 재사용
public final class DIContainer: Loggable, @unchecked Sendable {
    static let shared = DIContainer()

    /// 등록된 서비스 팩토리 클로저: [타입 식별자: [이름 식별자: 팩토리 클로저]]
    private var services: [ObjectIdentifier: [String: () -> Any]] = [:]

    /// 캐싱된 싱글톤 인스턴스: [타입 식별자: [이름 식별자: 인스턴스]]
    private var instances: [ObjectIdentifier: [String: Any]] = [:]

    /// 동시성 제어를 위한 재진입 가능한 Lock
    /// register 내부에서 resolve를 호출해도 데드락이 발생하지 않음
    private let lock = NSRecursiveLock()

    /// 의존성 구현체 등록
    /// - Parameters:
    ///   - type: 등록할 타입
    ///   - name: 같은 타입의 서로 다른 구현체를 구분하기 위한 식별자 (기본값: "default")
    ///   - object: 인스턴스를 생성하는 팩토리 클로저
    public static func register<T>(type: T.Type, name: String? = nil, object: @escaping () -> T) {
        shared.register(type: type, name: name, object: object)
    }

    /// 등록된 의존성 인스턴스 반환
    /// 싱글톤으로 동작하여 같은 타입과 이름으로 요청 시 동일한 인스턴스 반환
    /// - Parameters:
    ///   - type: 가져올 타입
    ///   - name: 구현체 식별자 (기본값: "default")
    /// - Returns: 등록된 싱글톤 인스턴스
    public static func resolve<T>(type: T.Type, name: String? = nil) -> T {
        shared.resolve(type: type, name: name)
    }
}

private extension DIContainer {
    private func register<T>(type: T.Type, name: String?, object: @escaping () -> T) {
        lock.lock()
        defer { lock.unlock() }

        let key = ObjectIdentifier(type)
        let nameKey = name ?? "default"
        var namedServices = services[key] ?? [:]

        if namedServices[nameKey] != nil {
            logWarning("[\(type)] '\(nameKey)' 이름으로 이미 등록되어 있습니다. 새로운 구현체로 덮어씁니다.")
        }

        namedServices[nameKey] = { object() }
        services[key] = namedServices
    }

    private func resolve<T>(type: T.Type, name: String?) -> T {
        lock.lock()
        defer { lock.unlock() }

        let key = ObjectIdentifier(type)
        let nameKey = name ?? "default"

        if let instance = instances[key]?[nameKey] as? T {
            return instance
        }

        guard let serviceFactory = services[key]?[nameKey] else {
            preconditionFailure("[\(type)] '\(nameKey)' 이름으로 등록되지 않았습니다. register를 먼저 호출하세요.")
        }

        let newInstance = serviceFactory()
        var namedInstances = instances[key] ?? [:]
        namedInstances[nameKey] = newInstance
        instances[key] = namedInstances

        guard let typedInstance = newInstance as? T else {
            preconditionFailure("[\(type)] 타입 캐스팅에 실패했습니다.")
        }

        return typedInstance
    }
}
