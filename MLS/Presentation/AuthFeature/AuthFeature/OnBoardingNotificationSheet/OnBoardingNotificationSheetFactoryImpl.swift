import AuthFeatureInterface
import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public struct OnBoardingNotificationSheetFactoryImpl: OnBoardingNotificationSheetFactory {
    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let openNotificationSettingUseCase: OpenNotificationSettingUseCase
    private let updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase
    private let updateUserInfoUseCase: UpdateUserInfoUseCase
    private let dictionaryMainViewFactory: DictionaryMainViewFactory

    public init(checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase, openNotificationSettingUseCase: OpenNotificationSettingUseCase, updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase, updateUserInfoUseCase: UpdateUserInfoUseCase, dictionaryMainViewFactory: DictionaryMainViewFactory) {
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.openNotificationSettingUseCase = openNotificationSettingUseCase
        self.updateNotificationAgreementUseCase = updateNotificationAgreementUseCase
        self.updateUserInfoUseCase = updateUserInfoUseCase
        self.dictionaryMainViewFactory = dictionaryMainViewFactory
    }

    public func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController & ModalPresentable {
        let viewController = OnBoardingNotificationSheetViewController(dictionaryMainViewFactory: dictionaryMainViewFactory)
        viewController.reactor = OnBoardingNotificationSheetReactor(selectedLevel: selectedLevel, selectedJobID: selectedJobID, checkNotificationPermissionUseCase: checkNotificationPermissionUseCase, openNotificationSettingUseCase: openNotificationSettingUseCase, updateNotificationAgreementUseCase: updateNotificationAgreementUseCase, updateUserInfoUseCase: updateUserInfoUseCase)
        return viewController
    }
}
