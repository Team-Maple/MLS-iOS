@testable import MLSCore
import Testing

/// 테스트를 위한 프로토콜 및 클래스
protocol Service {
    func perform() -> String
}

class ServiceA: Service {
    func perform() -> String {
        return "ServiceA"
    }
}

class ServiceB: Service {
    func perform() -> String {
        return "ServiceB"
    }
}

class ServiceWithDependency {
    let dependency: ServiceB

    init(dependency: ServiceB) {
        self.dependency = dependency
    }

    func perform() -> String {
        return "ServiceWithDependency using \(dependency.perform())"
    }
}

struct DIContainerTests {

    @Test("객체 등록 및 가져오기")
    func testRegisterAndResolve() async throws {
        DIContainer.register(type: Service.self, name: "TestA") { ServiceA() }
        DIContainer.register(type: Service.self, name: "TestB") { ServiceB() }

        let serviceA: Service = DIContainer.resolve(type: Service.self, name: "TestA")
        let serviceB: Service = DIContainer.resolve(type: Service.self, name: "TestB")

        #expect(serviceA.perform() == "ServiceA")
        #expect(serviceB.perform() == "ServiceB")
    }

    @Test("기본 이름 동작")
    func testDefaultName() async throws {
        DIContainer.register(type: Service.self) { ServiceA() as Service }

        let service: Service = DIContainer.resolve(type: Service.self)

        #expect(service.perform() == "ServiceA")
    }

    @Test("중복 등록 시 덮어쓰기")
    func testDuplicateRegistration() async throws {
        DIContainer.register(type: Service.self, name: "Duplicate") { ServiceA() as Service }
        DIContainer.register(type: Service.self, name: "Duplicate") { ServiceB() as Service }

        let service: Service = DIContainer.resolve(type: Service.self, name: "Duplicate")
        #expect(service.perform() == "ServiceB", "나중에 등록된 ServiceB가 반환되어야 함")
    }

    @Test("싱글톤 동작 검증 - 같은 인스턴스 반환")
    func testSingletonBehavior() async throws {
        DIContainer.register(type: Service.self, name: "Singleton") { ServiceA() }

        let instance1: Service = DIContainer.resolve(type: Service.self, name: "Singleton")
        let instance2: Service = DIContainer.resolve(type: Service.self, name: "Singleton")

        #expect(instance1 as AnyObject === instance2 as AnyObject, "같은 인스턴스를 반환해야 함")
    }

    @Test("타입 안전성 검증")
    func testTypeSafety() async throws {
        DIContainer.register(type: Service.self, name: "TypeTest") { ServiceA() as Service }

        let service: Service = DIContainer.resolve(type: Service.self, name: "TypeTest")
        #expect(service.perform() == "ServiceA")
    }

    @Test("동시성 안전성 - 여러 스레드에서 register/resolve 동시 호출")
    func testConcurrency() async throws {
        await withTaskGroup(of: Void.self) { group in
            for index in 0..<100 {
                group.addTask {
                    let name = "Concurrent\(index)"
                    DIContainer.register(type: Service.self, name: name) {
                        index % 2 == 0 ? ServiceA() as Service : ServiceB() as Service
                    }
                    let service: Service = DIContainer.resolve(type: Service.self, name: name)
                    let expected = index % 2 == 0 ? "ServiceA" : "ServiceB"
                    #expect(service.perform() == expected)
                }
            }
        }
    }

    @Test("재진입 안전성 - register 내부에서 resolve 호출 시 데드락 방지")
    func testReentrancy() async throws {
        DIContainer.register(type: ServiceB.self, name: "ReentryDependency") { ServiceB() }
        DIContainer.register(type: ServiceWithDependency.self, name: "ReentryMain") {
            let dependency: ServiceB = DIContainer.resolve(type: ServiceB.self, name: "ReentryDependency")
            return ServiceWithDependency(dependency: dependency)
        }

        let service: ServiceWithDependency = DIContainer.resolve(type: ServiceWithDependency.self, name: "ReentryMain")
        #expect(service.perform() == "ServiceWithDependency using ServiceB")
    }

    @Test("복잡한 의존성 체인 - A -> B -> C")
    func testDependencyChain() async throws {
        class ServiceC {
            func perform() -> String { "C" }
        }
        class ServiceBWithC {
            let c: ServiceC
            init(c: ServiceC) { self.c = c }
            func perform() -> String { "B->\(c.perform())" }
        }
        class ServiceAWithB {
            let b: ServiceBWithC
            init(b: ServiceBWithC) { self.b = b }
            func perform() -> String { "A->\(b.perform())" }
        }

        DIContainer.register(type: ServiceC.self, name: "ChainC") { ServiceC() }
        DIContainer.register(type: ServiceBWithC.self, name: "ChainB") {
            ServiceBWithC(c: DIContainer.resolve(type: ServiceC.self, name: "ChainC"))
        }
        DIContainer.register(type: ServiceAWithB.self, name: "ChainA") {
            ServiceAWithB(b: DIContainer.resolve(type: ServiceBWithC.self, name: "ChainB"))
        }

        let serviceA: ServiceAWithB = DIContainer.resolve(type: ServiceAWithB.self, name: "ChainA")
        #expect(serviceA.perform() == "A->B->C")
    }
}
