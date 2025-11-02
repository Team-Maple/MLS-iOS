import BaseFeature

public protocol ItemFilterBottomSheetFactory {
    func make(onFilterSelected: @escaping ([String]) -> Void) -> BaseViewController
}
