import BaseFeature
import DictionaryFeatureInterface

public struct ItemFilterBottomSheetFactoryImpl: ItemFilterBottomSheetFactory {
    public init() {}

    public func make(onFilterSelected: @escaping ([String]) -> Void) -> BaseViewController {
        let viewController = ItemFilterBottomSheetViewController()
        viewController.reactor = ItemFilterBottomSheetReactor()
        viewController.onFilterSelected = onFilterSelected
        return viewController
    }
}
