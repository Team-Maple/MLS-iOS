import AuthFeatureInterface
import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryMainViewFactoryImpl: DictionaryMainViewFactory {
    private let dictionaryMainListFactory: DictionaryMainListFactory
    private let searchFactory: DictionarySearchFactory
    private let notificationFactory: DictionaryNotificationFactory
    private let loginFactory: LoginFactory
    private let fetchProfileUseCase: FetchProfileUseCase

    public init(dictionaryMainListFactory: DictionaryMainListFactory, searchFactory: DictionarySearchFactory, notificationFactory: DictionaryNotificationFactory, loginFactory: LoginFactory, fetchProfileUseCase: FetchProfileUseCase) {
        self.dictionaryMainListFactory = dictionaryMainListFactory
        self.searchFactory = searchFactory
        self.notificationFactory = notificationFactory
        self.loginFactory = loginFactory
        self.fetchProfileUseCase = fetchProfileUseCase
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryMainReactor(fetchProfileUseCase: fetchProfileUseCase)
        let viewController = DictionaryMainViewController(dictionaryMainListFactory: dictionaryMainListFactory, searchFactory: searchFactory, notificationFactory: notificationFactory, loginFactory: loginFactory, reactor: reactor, )
        viewController.isBottomTabbarHidden = false
        viewController.reactor = reactor
        return viewController
    }
}
