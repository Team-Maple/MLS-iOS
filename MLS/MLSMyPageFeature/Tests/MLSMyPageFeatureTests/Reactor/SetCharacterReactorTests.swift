@testable import MLSMyPageFeature

import Testing

import MLSAuthFeatureInterface
import MLSAuthFeatureTesting
import MLSMyPageFeatureInterface
import MLSMyPageFeatureTesting

import ReactorKit
import RxBlocking
import RxSwift

@Suite("SetCharacterReactorTests")
struct SetCharacterReactorTests {
    private let testJob = Job(name: "전사", id: 1)

    // MARK: - Mutate

    @Test("viewWillAppear에서 jobList 불러오기")
    func viewWillAppear_setsJobList() throws {
        let reactor = makeSUT()
        
        let mutation = try reactor
            .mutate(action: .viewWillAppear)
            .toBlocking()
            .first()!

        switch mutation {
        case .setJobList(let jobList):
            #expect(jobList.count == 5)
            #expect(jobList.first?.name == "전사")
        default:
            #expect(Bool(false), "Expected setJobList")
        }
    }

    @Test("backButton 클릭하면 dismiss")
    func backButtonTapped_routesDismiss() throws {
        let reactor = makeSUT()
        
        let mutation = try reactor
            .mutate(action: .backButtonTapped)
            .toBlocking()
            .first()!

        switch mutation {
        case .navigateTo(let route):
            #expect(route == .dismiss)
        default:
            #expect(Bool(false), "Expected navigateTo")
        }
    }

    @Test("레벨 200 입력하면 level/buttonEnabled 활성화")
    func inputLevel_emitsThreeMutations() throws {
        let reactor = makeSUT()
        
        reactor.isStubEnabled = true
        reactor.stub.state.value.job = testJob

        let mutations = try reactor
            .mutate(action: .inputLevel(200))
            .toBlocking()
            .toArray()

        #expect(mutations.count == 3)

        switch mutations[0] {
        case .setLevel(let level):
            #expect(level == 200)
        default:
            #expect(Bool(false), "Expected setLevel")
        }

        switch mutations[1] {
        case .setButtonEnabled(let enabled):
            #expect(enabled == true)
        default:
            #expect(Bool(false), "Expected setButtonEnabled")
        }

        switch mutations[2] {
        case .setLevelValid(let valid):
            #expect(valid == true)
        default:
            #expect(Bool(false), "Expected setLevelValid")
        }
    }

    @Test("job 입력하면 role/buttonEnabled 활성화")
    func inputRole_emitsTwoMutations() throws {
        let reactor = makeSUT()
        
        reactor.isStubEnabled = true
        reactor.stub.state.value.level = 200

        let mutations = try reactor
            .mutate(action: .inputRole(testJob))
            .toBlocking()
            .toArray()

        #expect(mutations.count == 2)

        switch mutations[0] {
        case .setRole(let job):
            #expect(job?.name == "전사")
        default:
            #expect(Bool(false), "Expected setRole")
        }

        switch mutations[1] {
        case .setButtonEnabled(let enabled):
            #expect(enabled == true)
        default:
            #expect(Bool(false), "Expected setButtonEnabled")
        }
    }

    @Test("입력값 없이 applyButton 클릭하면 error 방출")
    func applyButtonTapped_empty_routesError() throws {
        let reactor = makeSUT()
        
        let mutation = try reactor
            .mutate(action: .applyButtonTapped)
            .toBlocking()
            .first()!

        switch mutation {
        case .navigateTo(let route):
            #expect(route == .error)
        default:
            #expect(Bool(false), "Expected navigateTo")
        }
    }

    @Test("유효한 값 입력 후 applyButton 클릭하면 dismissWithSave")
    func applyButtonTapped_valid_routesDismissWithSave() throws {
        let reactor = makeSUT()
        
        reactor.isStubEnabled = true
        reactor.stub.state.value.level = 200
        reactor.stub.state.value.job = testJob

        let mutation = try reactor
            .mutate(action: .applyButtonTapped)
            .toBlocking()
            .first()!

        switch mutation {
        case .navigateTo(let route):
            #expect(route == .dismissWithSave)
        default:
            #expect(Bool(false), "Expected navigateTo")
        }
    }
}

private extension SetCharacterReactorTests {
    func makeSUT() -> SetCharacterReactor {
        return SetCharacterReactor(
            checkEmptyUseCase: CheckEmptyLevelAndRoleUseCaseImpl(),
            checkValidLevelUseCase: CheckValidLevelUseCaseImpl(),
            authRepository: MockAuthAPIRepository()
        )
    }
}
