import BaseFeature
import DictionaryFeatureInterface

public struct ItemFilterBottomSheetFactoryImpl: ItemFilterBottomSheetFactory {
    private let sharedReactor = ItemFilterBottomSheetReactor()
    public init() {}

    public func make(onFilterSelected: @escaping ([(String, String)]) -> Void) -> BaseViewController {
        // let reactor = ItemFilterBottomSheetReactor() // 매번 새로 리액터를 생성하기 때문에 초기화
        let viewController = ItemFilterBottomSheetViewController()
        viewController.reactor = sharedReactor
        viewController.onFilterSelected = onFilterSelected
        return viewController
    }
}
