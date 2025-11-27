import AuthFeatureInterface
import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public struct OnBoardingNotificationSheetFactoryImpl: OnBoardingNotificationSheetFactory {
    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let openNotificationSettingUseCase: OpenNotificationSettingUseCase
    private let updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase
    private let updateUserInfoUseCase: UpdateUserInfoUseCase
    private let appCoordinator: () -> AppCoordinatorProtocol

    public init(
        checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase,
        openNotificationSettingUseCase: OpenNotificationSettingUseCase,
        updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase,
        updateUserInfoUseCase: UpdateUserInfoUseCase,
        appCoordinator: @escaping () -> AppCoordinatorProtocol
    ) {
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.openNotificationSettingUseCase = openNotificationSettingUseCase
        self.updateNotificationAgreementUseCase = updateNotificationAgreementUseCase
        self.updateUserInfoUseCase = updateUserInfoUseCase
        self.appCoordinator = appCoordinator
    }

    public func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController & ModalPresentable {
        let viewController = OnBoardingNotificationSheetViewController(appCoordinator: appCoordinator())
        viewController.isBottomTabbarHidden = true
        viewController.reactor = OnBoardingNotificationSheetReactor(
            selectedLevel: selectedLevel,
            selectedJobID: selectedJobID,
            checkNotificationPermissionUseCase: checkNotificationPermissionUseCase,
            openNotificationSettingUseCase: openNotificationSettingUseCase,
            updateNotificationAgreementUseCase: updateNotificationAgreementUseCase,
            updateUserInfoUseCase: updateUserInfoUseCase
        )
        return viewController
    }
}
