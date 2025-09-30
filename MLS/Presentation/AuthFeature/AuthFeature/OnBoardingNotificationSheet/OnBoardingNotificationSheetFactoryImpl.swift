import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct OnBoardingNotificationSheetFactoryImpl: OnBoardingNotificationSheetFactory {
    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let openNotificationSettingUseCase: OpenNotificationSettingUseCase
    private let updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase
    
    public init(checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase, openNotificationSettingUseCase: OpenNotificationSettingUseCase, updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase) {
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.openNotificationSettingUseCase = openNotificationSettingUseCase
        self.updateNotificationAgreementUseCase = updateNotificationAgreementUseCase
    }

    public func make() -> BaseViewController & ModalPresentable {
        let viewController = OnBoardingNotificationSheetViewController()
        viewController.reactor = OnBoardingNotificationSheetReactor(checkNotificationPermissionUseCase: checkNotificationPermissionUseCase, openNotificationSettingUseCase: openNotificationSettingUseCase, updateNotificationAgreementUseCase: updateNotificationAgreementUseCase)
        return viewController
    }
}
