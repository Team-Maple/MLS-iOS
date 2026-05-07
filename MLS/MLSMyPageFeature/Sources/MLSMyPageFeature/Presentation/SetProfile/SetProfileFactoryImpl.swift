import MLSCore
import MLSMyPageFeatureInterface

public final class SetProfileFactoryImpl: SetProfileFactory {
    private let selectImageFactory: SelectImageFactory
    private let checkNickNameUseCase: CheckNickNameUseCase
    private let logoutUseCase: LogoutUseCase
    private let withdrawUseCase: WithdrawUseCase
    private let fetchProfileUseCase: FetchProfileUseCase
    private let myPageRepository: MyPageRepository

    public init(
        selectImageFactory: SelectImageFactory,
        checkNickNameUseCase: CheckNickNameUseCase,
        logoutUseCase: LogoutUseCase,
        withdrawUseCase: WithdrawUseCase,
        fetchProfileUseCase: FetchProfileUseCase,
        myPageRepository: MyPageRepository
    ) {
        self.selectImageFactory = selectImageFactory
        self.checkNickNameUseCase = checkNickNameUseCase
        self.myPageRepository = myPageRepository
        self.logoutUseCase = logoutUseCase
        self.withdrawUseCase = withdrawUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
    }

    public func make() -> BaseViewController {
        let viewController = SetProfileViewController(selectImageFactory: selectImageFactory)
        viewController.reactor = SetProfileReactor(checkNickNameUseCase: checkNickNameUseCase, logoutUseCase: logoutUseCase, withdrawUseCase: withdrawUseCase, fetchProfileUseCase: fetchProfileUseCase, myPageRepository: myPageRepository)
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
