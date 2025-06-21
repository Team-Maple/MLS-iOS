import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public struct SortedBottomSheetFactoryImpl: SortedBottomSheetFactory {

    public init() {}

    public func make(sortedOptions: [String], selectedIndex: Int) -> BaseViewController & ModalPresentable {
        let viewController = SortedBottomSheetViewController()
        viewController.reactor = SortedBottomSheetReactor(sortedOptions: sortedOptions, selectedIndex: selectedIndex)
        return viewController
    }
}
