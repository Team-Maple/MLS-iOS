import XCTest

@testable import Core
@testable import Data
@testable import DomainInterface

class DIContainerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        DIContainer.resetForTesting()
    }

    override func tearDown() {
        DIContainer.resetForTesting()
        super.tearDown()
    }

    /// 객체 등록 및 가져오기 테스트
    func testRegisterAndResolve() {
        DIContainer.register(type: Service.self, name: "A") { ServiceA() }
        DIContainer.register(type: Service.self, name: "B") { ServiceB() }

        let serviceA: Service? = DIContainer.resolve(type: Service.self, name: "A")
        let serviceB: Service? = DIContainer.resolve(type: Service.self, name: "B")

        XCTAssertNotNil(serviceA)
        XCTAssertNotNil(serviceB)
        XCTAssertEqual(serviceA?.perform(), "ServiceA")
        XCTAssertEqual(serviceB?.perform(), "ServiceB")
    }

    /// 기본 이름 동작 테스트
    func testDefaultName() {
        DIContainer.register(type: Service.self) { ServiceA() as Service }

        let service: Service? = DIContainer.resolve(type: Service.self)

        XCTAssertNotNil(service)
        XCTAssertEqual(service?.perform(), "ServiceA")
    }

    // 중복 등록 시 fatalError 테스트
    // fatalError 구문은 주석처리하고 테스트 진행
//    func testDuplicateRegistration() {
//        DIContainer.register(type: Service.self, name: "A") { ServiceA() as Service }
//        DIContainer.register(type: Service.self, name: "A") { ServiceB() as Service }
//
//        let service: Service? = DIContainer.resolve(type: Service.self, name: "A")
//        XCTAssertNotNil(service)
//        XCTAssertEqual(service?.perform(), "ServiceB", "Expected ServiceB to override ServiceA for name 'A'")
//    }

    /// 등록되지 않은 객체 불러오기 테스트
    func testResolveUnregistered() {
        let service: Service? = DIContainer.resolve(type: Service.self, name: "Unknown")

        XCTAssertNil(service)
    }

    /// 타입 안전성 테스트
    func testTypeSafety() {
        DIContainer.register(type: Service.self, name: "A") { ServiceA() as Service }

        let anotherService: AnotherService? = DIContainer.resolve(type: AnotherService.self, name: "A")

        XCTAssertNil(anotherService)
    }

    /// 동시성 테스트 (여러 스레드에서 register/resolve 호출)
    func testConcurrency() {
        let expectation = XCTestExpectation(description: "Concurrent register and resolve")
        let queue = DispatchQueue(label: "test.concurrent.queue", attributes: .concurrent)
        let group = DispatchGroup()

        // 동시에 등록 및 호출
        for index in 0..<100 {
            group.enter()
            queue.async {
                let name = "Test\(index)"
                DIContainer.register(type: Service.self, name: name) {
                    index % 2 == 0 ? ServiceA() as Service : ServiceB() as Service
                }
                let service: Service? = DIContainer.resolve(type: Service.self, name: name)
                XCTAssertNotNil(service)
                XCTAssertEqual(service?.perform(), index % 2 == 0 ? "ServiceA" : "ServiceB")
                group.leave()
            }
        }

        group.notify(queue: .main) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}

/// 테스트를 위한 임시 객체
extension DIContainerTests {
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

    protocol AnotherService {
        func execute() -> String
    }

    class AnotherServiceX: AnotherService {
        func execute() -> String {
            return "AnotherServiceX"
        }
    }
}

// 테스트를 위한 서비스 초기화 함수
extension DIContainer {
    public static func resetForTesting() {
        shared.resetForTesting()
    }

    private func resetForTesting() {
        serviceQueue.sync {
            services.removeAll()
        }
    }
}
