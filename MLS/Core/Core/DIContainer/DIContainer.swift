import Foundation

/// 의존성 주입을 위한 컨테이너
public final class DIContainer {
    static let shared = DIContainer()
    // 저장 타입식별자 : [이름 식별자 : 객체 클로저] 형태
    private var services: [ObjectIdentifier: [String: () -> Any]] = [:]
    private var instances: [ObjectIdentifier: [String: Any]] = [:]
    // 동시성 문제를 해결하기 위한 큐 생성
    private let serviceQueue = DispatchQueue(label: "com.dicontainer.serviceQueue")

    /// 구현체 등록을 위한 함수
    /// - Parameters:
    ///   - type: 등록하는 객체의 타입
    ///   - name: 같은 인터페이스끼리의 식별을 위한 문자열 식별자
    ///   - component: 저장할 객체
    public static func register<T>(type: T.Type, name: String? = nil, object: @escaping () -> T) {
        shared.register(type: type, name: name, object: object)
    }

    /// 등록된 구현체를 가져오기 위한 함수
    /// - Parameters:
    ///   - type: 가져올 객체의 타입
    ///   - name: 가져올 객체의 식별자
    /// - Returns: 저장되어있던 객체
    public static func resolve<T>(type: T.Type, name: String? = nil) -> T {
        shared.resolve(type: type, name: name)
    }
}

private extension DIContainer {
    private func register<T>(type: T.Type, name: String?, object: @escaping () -> T) {
        serviceQueue.sync {
            let key = ObjectIdentifier(type)
            var namedServices = services[key] ?? [:]
            // 같은 식별자로 이미 저장되어있는 객체가 있다면 fatalError
            if namedServices[name ?? "default"] != nil {
                fatalError("\(type)타입과 \(name ?? "default")이름이 이미 존재")
            }
            // 문자열 식별자를 입력하지 않으면 default로 간주하여 저장
            namedServices[name ?? "default"] = { object() }
            services[key] = namedServices
        }
    }

    private func resolve<T>(type: T.Type, name: String?) -> T {
//        serviceQueue.sync {
        let key = ObjectIdentifier(type)
        let nameKey = name ?? "default"

        if let instance = instances[key]?[nameKey] as? T {
            return instance
        }

        guard let services = services[key]?[nameKey] else {
            fatalError("\(type) 타입과 \(nameKey) 이름이 등록되어 있지 않습니다.")
        }

        let newInstance = services()
        var namedInstances = instances[key] ?? [:]
        namedInstances[nameKey] = newInstance
        instances[key] = namedInstances
        return newInstance as! T
//        }
    }
}
