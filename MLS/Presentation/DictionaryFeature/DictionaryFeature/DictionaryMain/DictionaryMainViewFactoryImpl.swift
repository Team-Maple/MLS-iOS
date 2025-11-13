import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryMainViewFactoryImpl: DictionaryMainViewFactory {
    private let dictionaryMainListFactory: DictionaryMainListFactory
    private let searchFactory: DictionarySearchFactory
    private let notificationFactory: DictionaryNotificationFactory
    private let checkLoginUseCase: CheckLoginUseCase

    public init(dictionaryMainListFactory: DictionaryMainListFactory, searchFactory: DictionarySearchFactory, notificationFactory: DictionaryNotificationFactory, checkLoginUseCase: CheckLoginUseCase) {
        self.dictionaryMainListFactory = dictionaryMainListFactory
        self.searchFactory = searchFactory
        self.notificationFactory = notificationFactory
        self.checkLoginUseCase = checkLoginUseCase
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryMainReactor(checkLoginUseCase: checkLoginUseCase)
        let viewController = DictionaryMainViewController(dictionaryMainListFactory: dictionaryMainListFactory, searchFactory: searchFactory, notificationFactory: notificationFactory, reactor: reactor)
        viewController.reactor = reactor
        return viewController
    }
}
