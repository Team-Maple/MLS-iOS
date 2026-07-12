import MLSAuthFeatureInterface
import MLSCore
import MLSDictionaryFeatureInterface
import MLSMyPageFeatureInterface

public final class DictionaryMainViewFactoryImpl: DictionaryMainViewFactory {
    private let dictionaryMainListFactory: DictionaryMainListFactory
    private let searchFactory: DictionarySearchFactory
    private let notificationFactory: DictionaryNotificationFactory
    private let loginFactory: LoginFactory
    private let userDefaultsRepository: DictionaryUserDefaultsRepository
    private let fetchProfileUseCase: FetchProfileUseCase

    public init(dictionaryMainListFactory: DictionaryMainListFactory, searchFactory: DictionarySearchFactory, notificationFactory: DictionaryNotificationFactory, loginFactory: LoginFactory, userDefaultsRepository: DictionaryUserDefaultsRepository, fetchProfileUseCase: FetchProfileUseCase) {
        self.dictionaryMainListFactory = dictionaryMainListFactory
        self.searchFactory = searchFactory
        self.notificationFactory = notificationFactory
        self.loginFactory = loginFactory
        self.userDefaultsRepository = userDefaultsRepository
        self.fetchProfileUseCase = fetchProfileUseCase
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryMainReactor(userDefaultsRepository: userDefaultsRepository, fetchProfileUseCase: fetchProfileUseCase)
        let viewController = DictionaryMainViewController(dictionaryMainListFactory: dictionaryMainListFactory, searchFactory: searchFactory, notificationFactory: notificationFactory, loginFactory: loginFactory, reactor: reactor, )
        viewController.isBottomTabbarHidden = false
        viewController.reactor = reactor
        return viewController
    }
}
