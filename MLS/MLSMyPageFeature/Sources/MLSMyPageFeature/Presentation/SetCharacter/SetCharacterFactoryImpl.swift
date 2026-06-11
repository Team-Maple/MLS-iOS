import MLSAuthFeatureInterface
import MLSCore
import MLSMyPageFeatureInterface

public struct SetCharacterFactoryImpl: SetCharacterFactory {
    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let authRepository: AuthAPIRepository
    private let myPageRepository: MyPageRepository

    public init(
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        authRepository: AuthAPIRepository,
        myPageRepository: MyPageRepository
    ) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.authRepository = authRepository
        self.myPageRepository = myPageRepository
    }

    public func make() -> BaseViewController {
        let viewController = SetCharacterViewController()
        viewController.reactor = SetCharacterReactor(
            checkEmptyUseCase: checkEmptyUseCase,
            checkValidLevelUseCase: checkValidLevelUseCase,
            authRepository: authRepository,
            myPageRepository: myPageRepository
        )
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
