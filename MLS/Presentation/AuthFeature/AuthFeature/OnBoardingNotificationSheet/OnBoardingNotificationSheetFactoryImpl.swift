import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct OnBoardingNotificationSheetFactoryImpl: OnBoardingNotificationSheetFactory {
    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let openNotificationSettingUseCase: OpenNotificationSettingUseCase
    private let updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase
    private let updateUserInfoUseCase: UpdateUserInfoUseCase
    
    public init(checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase, openNotificationSettingUseCase: OpenNotificationSettingUseCase, updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase, updateUserInfoUseCase: UpdateUserInfoUseCase) {
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.openNotificationSettingUseCase = openNotificationSettingUseCase
        self.updateNotificationAgreementUseCase = updateNotificationAgreementUseCase
        self.updateUserInfoUseCase = updateUserInfoUseCase
    }

    public func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController & ModalPresentable {
        let viewController = OnBoardingNotificationSheetViewController()
        viewController.reactor = OnBoardingNotificationSheetReactor(selectedLevel: selectedLevel, selectedJobID: selectedJobID, checkNotificationPermissionUseCase: checkNotificationPermissionUseCase, openNotificationSettingUseCase: openNotificationSettingUseCase, updateNotificationAgreementUseCase: updateNotificationAgreementUseCase, updateUserInfoUseCase: updateUserInfoUseCase)
        return viewController
    }
}
