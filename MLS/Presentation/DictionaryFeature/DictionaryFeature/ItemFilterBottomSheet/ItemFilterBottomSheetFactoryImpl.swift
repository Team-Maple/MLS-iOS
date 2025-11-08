import BaseFeature
import DictionaryFeatureInterface

public struct ItemFilterBottomSheetFactoryImpl: ItemFilterBottomSheetFactory {
    public init() {}

    public func make(onFilterSelected: @escaping ([(String, String)]) -> Void) -> BaseViewController {
        let reactor = ItemFilterBottomSheetReactor()
        let viewController = ItemFilterBottomSheetViewController()
        viewController.reactor = reactor
        viewController.onFilterSelected = onFilterSelected
        return viewController
    }
}
