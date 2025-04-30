import Foundation

public final class DIContainer {
    private static let shared = DIContainer()
    private var services: [ObjectIdentifier: [String: () -> Any]] = [:]
    private let serviceQueue = DispatchQueue(label: "com.dicontainer.serviceQueue")

    private init() {}

    public static func register<T>(type: T.Type, name: String? = nil, component: @escaping () -> T) {
        shared.register(type: type, name: name, component: component)
    }

    public static func resolve<T>(type: T.Type, name: String? = nil) -> T? {
        shared.resolve(type: type, name: name)
    }
}

private extension DIContainer {
    private func register<T>(type: T.Type, name: String?, component: @escaping () -> T) {
        serviceQueue.sync {
            let key = ObjectIdentifier(type)
            var namedServices = services[key] ?? [:]
            if namedServices[name ?? "default"] != nil {
                fatalError("\(type)타입과 \(name ?? "default")이름이 이미 존재")
            }
            namedServices[name ?? "default"] = { component() }
            services[key] = namedServices
        }
    }

    private func resolve<T>(type: T.Type, name: String?) -> T? {
        serviceQueue.sync {
            let key = ObjectIdentifier(type)
            guard let namedServices = services[key], let result = namedServices[name ?? "default"], let instance = result() as? T else {
                return nil
            }
            return instance
        }
    }
}
