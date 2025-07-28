import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public struct SortedBottomSheetFactoryImpl: SortedBottomSheetFactory {
    public init() {}

    public func make(sortedOptions: [SortType], selectedIndex: Int, onSelectedIndex: @escaping (Int) -> Void) -> BaseViewController & ModalPresentable {
        let viewController = SortedBottomSheetViewController()
        viewController.reactor = SortedBottomSheetReactor(sortTypes: sortedOptions, selectedIndex: selectedIndex)
        viewController.onSelectedIndex = onSelectedIndex
        return viewController
    }
}
