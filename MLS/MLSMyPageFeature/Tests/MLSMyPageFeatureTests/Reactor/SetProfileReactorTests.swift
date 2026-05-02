@testable import MLSMyPageFeature

import Testing

import MLSAuthFeatureTesting
import MLSMyPageFeatureInterface
import MLSMyPageFeatureTesting

import ReactorKit
import RxBlocking
import RxSwift

@Suite("SetProfileReactorTests")
struct SetProfileReactorTests {
    @Test("bottomSheet 버튼 클릭하면 imageBottomSheet 이동")
    func showBottomSheet_routesBottomSheet() throws {
        let reactor = makeSUT()

        let mutation = try reactor.mutate(action: .showBottomSheet)
            .toBlocking()
            .first()!

        #expect(mutation == .toNavigate(.imageBottomSheet))
    }

    @Test("backButton 클릭하면 dismiss")
    func back_normal_routesDismiss() throws {
        let reactor = makeSUT()

        let mutation = try reactor.mutate(action: .backButtonTapped)
            .toBlocking()
            .first()!

        #expect(mutation == .toNavigate(.dismiss))
    }

    @Test("editButton클릭하면 beginEditing")
    func edit_normal_beginEditing() throws {
        let reactor = makeSUT()

        let mutation = try reactor.mutate(action: .editButtonTapped)
            .toBlocking()
            .first()!

        #expect(mutation == .beginEditting)
    }

    @Test("logoutButton 클릭하면 logoutAlert")
    func logoutButtonTapped_routesAlert() throws {
        let reactor = makeSUT()

        let mutation = try reactor.mutate(action: .logoutButtonTapped)
            .toBlocking()
            .first()!

        #expect(mutation == .toNavigate(.logoutAlert))
    }

    @Test("withdrawButton 클릭 하면 withdrawAlert")
    func withdrawButtonTapped_routesAlert() throws {
        let reactor = makeSUT()

        let mutation = try reactor.mutate(action: .withdrawButtonTapped)
            .toBlocking()
            .first()!

        #expect(mutation == .toNavigate(.withdrawAlert))
    }
}

private extension SetProfileReactorTests {
   func makeSUT() -> SetProfileReactor {
        let authRepo = MockAuthAPIRepository()
        let tokenRepo = MockTokenRepository()
        return SetProfileReactor(
            checkNickNameUseCase: CheckNickNameUseCaseImpl(),
            logoutUseCase: LogoutUseCaseImpl(
                repository: tokenRepo
            ),
            withdrawUseCase: WithdrawUseCaseImpl(authRepository: authRepo, tokenRepository: tokenRepo),
            fetchProfileUseCase: FetchProfileUseCaseImpl(
                repository: MockMyPageRepository()
            ),
            myPageRepository: MockMyPageRepository()
        )
    }
}
