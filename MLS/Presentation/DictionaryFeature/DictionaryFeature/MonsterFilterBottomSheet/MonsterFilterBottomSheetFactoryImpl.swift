import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public struct MonsterFilterBottomSheetFactoryImpl: MonsterFilterBottomSheetFactory {

    public init() {}

    public func make() -> BaseViewController & ModalPresentable {
        let viewController = MonsterFilterBottomSheetViewController()
        viewController.reactor = MonsterFilterBottomSheetReactor()
        return viewController
    }
}
