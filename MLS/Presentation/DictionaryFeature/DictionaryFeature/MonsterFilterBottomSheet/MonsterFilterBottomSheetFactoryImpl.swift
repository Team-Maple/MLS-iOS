import Foundation

import BaseFeature
import DictionaryFeatureInterface

public struct MonsterFilterBottomSheetFactoryImpl: MonsterFilterBottomSheetFactory {
    public init() {}

    public func make(startLevel: Int, endLevel: Int, onFilterSelected: @escaping (Int, Int) -> Void) -> BaseViewController & ModalPresentable {
        let viewController = MonsterFilterBottomSheetViewController()
        viewController.startLevel = CGFloat(startLevel)
        viewController.endLevel = CGFloat(endLevel)
        viewController.reactor = MonsterFilterBottomSheetReactor(startLevel: startLevel, endLevel: endLevel)
        viewController.onFilterSelected = onFilterSelected

        return viewController
    }
}
