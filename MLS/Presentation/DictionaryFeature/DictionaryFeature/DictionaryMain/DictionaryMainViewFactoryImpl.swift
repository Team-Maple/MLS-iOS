import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryMainViewFactoryImpl: DictionaryMainViewFactory {
    private let dictionaryMainListFactory: DictionaryMainListFactory
    private let searchFactory: DictionarySearchFactory
    private let notificationFactory: DictionaryNotificationFactory

    public init(dictionaryMainListFactory: DictionaryMainListFactory, searchFactory: DictionarySearchFactory, notificationFactory: DictionaryNotificationFactory) {
        self.dictionaryMainListFactory = dictionaryMainListFactory
        self.searchFactory = searchFactory
        self.notificationFactory = notificationFactory
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryMainReactor()
        let viewController = DictionaryMainViewController(dictionaryMainListFactory: dictionaryMainListFactory, searchFactory: searchFactory, notificationFactory: notificationFactory, reactor: reactor)
        viewController.reactor = reactor
        return viewController
    }
}
