import MLSCore
import MLSDesignSystem

public protocol SortedBottomSheetFactory {
    func make(sortedOptions: [SortType], selectedIndex: Int, onSelectedIndex: @escaping (Int) -> Void) -> BaseViewController & ModalPresentable
}
