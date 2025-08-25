import BaseFeature
import DictionaryFeatureInterface

public struct MonsterFilterBottomSheetFactoryImpl: MonsterFilterBottomSheetFactory {
    public init() {}

    public func make() -> BaseViewController & ModalPresentable {
        let viewController = MonsterFilterBottomSheetViewController()
        viewController.reactor = MonsterFilterBottomSheetReactor()
        return viewController
    }
}
