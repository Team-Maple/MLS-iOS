import BaseFeature
import MyPageFeatureInterface

public final class MyPageMainFactoryImpl: MyPageMainFactory {
    private let setProfileFactory: SetProfileFactory
    private let setCharacterFactory: SetCharacterFactory

    public init(setProfileFactory: SetProfileFactory, setCharacterFactory: SetCharacterFactory) {
        self.setProfileFactory = setProfileFactory
        self.setCharacterFactory = setCharacterFactory
    }

    public func make() -> BaseViewController {
        let viewController = MyPageMainViewController(setProfileFactory: setProfileFactory, setCharacterFactory: setCharacterFactory)
        viewController.reactor = MyPageMainReactor()
        return viewController
    }
}
