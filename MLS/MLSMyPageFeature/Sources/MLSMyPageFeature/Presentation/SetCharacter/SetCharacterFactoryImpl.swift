import MLSAuthFeatureInterface
import MLSCore
import MLSMyPageFeatureInterface

public struct SetCharacterFactoryImpl: SetCharacterFactory {
    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let authRepository: AuthAPIRepository

    public init(
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        authRepository: AuthAPIRepository
    ) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.authRepository = authRepository
    }

    public func make() -> BaseViewController {
        let viewController = SetCharacterViewController()
        viewController.reactor = SetCharacterReactor(
            checkEmptyUseCase: checkEmptyUseCase,
            checkValidLevelUseCase: checkValidLevelUseCase,
            authRepository: authRepository
        )
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
