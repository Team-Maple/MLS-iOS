@testable import Core
import Testing

struct TestViewModel: Loggable {
    func testLogs() {
        logDebug("Debug 로그 테스트")
        logInfo("Info 로그 테스트")
        logWarning("Warning 로그 테스트")
        logError("Error 로그 테스트")
        logCritical("Critical 로그 테스트")
    }
}

class TestManager: Loggable {
    func testLogs() {
        logDebug("Debug 로그 (class)")
        logInfo("Info 로그 (class)")
        logWarning("Warning 로그 (class)")
        logError("Error 로그 (class)")
        logCritical("Critical 로그 (class)")
    }
}

struct LoggerTests {

    @Test("Subsystem 자동 추출 검증 - Struct")
    func testSubsystemExtractionStruct() async throws {
        // subsystem은 타입이 정의된 모듈 이름이어야 함
        let subsystem = TestViewModel.subsystem
        let category = TestViewModel.category

        // DIContainerTests 모듈에 정의되어 있으므로
        #expect(subsystem == "DIContainerTests")
        #expect(category == "TestViewModel")
    }

    @Test("Subsystem 자동 추출 검증 - Class")
    func testSubsystemExtractionClass() async throws {
        let subsystem = TestManager.subsystem
        let category = TestManager.category

        #expect(subsystem == "DIContainerTests")
        #expect(category == "TestManager")
    }

    @Test("Struct에서 Loggable 사용 테스트")
    func testLoggableWithStruct() async throws {
        let viewModel = TestViewModel()

        // 로그 출력 (Console.app에서 확인 가능)
        // subsystem: "DIContainerTests", category: "TestViewModel"
        viewModel.testLogs()

        // 에러 없이 실행되면 성공
        #expect(true)
    }

    @Test("Class에서 Loggable 사용 테스트")
    func testLoggableWithClass() async throws {
        let manager = TestManager()

        // 로그 출력 (Console.app에서 확인 가능)
        // subsystem: "DIContainerTests", category: "TestManager"
        manager.testLogs()

        // 에러 없이 실행되면 성공
        #expect(true)
    }

    @Test("동시성 안전성 테스트 - 같은 Logger 동시 접근")
    func testConcurrentLoggerAccess() async throws {
        // 100개 스레드가 동시에 같은 Logger 사용
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<100 {
                group.addTask {
                    let vm = TestViewModel()
                    vm.logInfo("동시 로그 \(i)")
                }
            }
        }

        // 크래시 없이 완료되면 성공
        #expect(true)
    }

    @Test("여러 타입에서 동시에 로깅")
    func testMultipleTypesConcurrent() async throws {
        let viewModel = TestViewModel()
        let manager = TestManager()

        // 동시에 로그 출력
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                viewModel.testLogs()
            }
            group.addTask {
                manager.testLogs()
            }
        }

        // 에러 없이 실행되면 성공
        #expect(true)
    }
}
