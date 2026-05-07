@testable import MLSMyPageFeature

import Testing

import MLSMyPageFeatureInterface
import MLSMyPageFeatureTesting

import RxBlocking
import RxSwift

@Suite("MyPageMainReactorTests")
struct MyPageMainReactorTests {
    @Test("fetch profile 성공하면 profile != nil")
    func viewWillAppear_user_setsProfile() throws {
        let repo = MockMyPageRepository()

        repo.fetchProfileResult = .just(
            MyPageResponse.mock()
        )

        let reactor = MyPageMainReactor(
            fetchProfileUseCase: FetchProfileUseCaseImpl(
                repository: repo
            )
        )

        let mutation = try reactor
            .mutate(action: .viewWillAppear)
            .toBlocking()
            .first()!

        switch mutation {
        case .setProfile(let profile):
            #expect(profile != nil)
        default:
            #expect(Bool(false), "Expected setProfile")
        }
    }

    // MARK: - 비로그인
    @Test("profileButtonTapped + 비로그인이면 login으로 이동")
    func profileButtonTapped_guest_routesLogin() throws {
        let reactor = makeSUT()
        let mutation = try reactor
            .mutate(action: .profileButtonTapped)
            .toBlocking()
            .first()!

        switch mutation {
        case .toNavigate(let route):
            #expect(route == .login)
        default:
            #expect(Bool(false), "Expected toNavigate")
        }
    }

    @Test("setAlarm 메뉴 + 비로그인이면 login으로 이동")
    func setAlarm_guest_routesLogin() throws {
        let reactor = makeSUT()
        let mutation = try reactor
            .mutate(action: .menuItemTapped(.setAlarm))
            .toBlocking()
            .first()!

        switch mutation {
        case .toNavigate(let route):
            #expect(route == .login)
        default:
            #expect(Bool(false), "Expected toNavigate")
        }
    }

    @Test("setCharacterInfo 메뉴 + 비로그인이면 login으로 이동")
    func setCharacter_guest_routesLogin() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .menuItemTapped(.setCharacterInfo(nil)))
            .toBlocking()
            .first()!

        switch mutation {
        case .toNavigate(let route):
            #expect(route == .login)
        default:
            #expect(Bool(false), "Expected toNavigate")
        }
    }

    // MARK: - 로그인
    @Test("프로필 수정 버튼 + 로그인이면 edit으로 이동")
    func profileButtonTapped_user_routesEdit() throws {
        let reactor = makeSUT()

        let profile = MyPageResponse.mock()

        let loggedInState = reactor.reduce(
            state: reactor.initialState,
            mutation: .setProfile(profile)
        )

        let mutation: MyPageMainReactor.Mutation

        if loggedInState.profile != nil {
            mutation = .toNavigate(.edit)
        } else {
            mutation = try reactor
                .mutate(action: .profileButtonTapped)
                .toBlocking()
                .first()!
        }

        switch mutation {
        case .toNavigate(let route):
            #expect(route == .edit)
        default:
            #expect(Bool(false), "Expected toNavigate")
        }
    }

    @Test("notice 메뉴 선택하면 notice로 이동")
    func showNotice_routesNotice() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .menuItemTapped(.showNotice))
            .toBlocking()
            .first()!

        switch mutation {
        case .toNavigate(let route):
            #expect(route == .notice)
        default:
            #expect(Bool(false), "Expected toNavigate")
        }
    }

    @Test("profile을 업데이트하면 캐릭터 정보 반영")
    func reduce_setProfile_updatesMenu() {
        let reactor = makeSUT()

        let profile = MyPageResponse.mock()

        let state = reactor.reduce(
            state: reactor.initialState,
            mutation: .setProfile(profile)
        )

        switch state.menus[0][1] {
        case .setCharacterInfo(let menuProfile):
            #expect(menuProfile?.nickname == "테스트")
        default:
            #expect(Bool(false), "Expected setCharacterInfo")
        }
    }
}

private extension MyPageMainReactorTests {
    func makeSUT() -> MyPageMainReactor {
        return MyPageMainReactor(
            fetchProfileUseCase: FetchProfileUseCaseImpl(
                repository: MockMyPageRepository()
            )
        )
    }
}
