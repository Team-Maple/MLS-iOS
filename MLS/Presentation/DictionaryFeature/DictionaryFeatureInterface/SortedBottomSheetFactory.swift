import BaseFeature

public protocol SortedBottomSheetFactory {
    func make(sortedOptions: [String], selectedIndex: Int) -> BaseViewController & ModalPresentable
}
