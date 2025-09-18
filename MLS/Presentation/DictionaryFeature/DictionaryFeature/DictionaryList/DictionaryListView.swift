import UIKit

import BaseFeature
import DesignSystem

final class DictionaryListView: BaseListView {
    // MARK: - Init
    init(isFilterHidden: Bool) {
        let sortButton: UIButton = {
            let button = UIButton()
            button.setAttributedTitle(.makeStyledString(font: .b_s_r, text: "가나다 순"), for: .normal)
            button.setImage(DesignSystemAsset.image(named: "lineArrowDown")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .neutral900
            button.setTitleColor(.neutral900, for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
            return button
        }()

        let filterButton: UIButton = {
            let button = UIButton()
            button.setAttributedTitle(.makeStyledString(font: .b_s_r, text: "필터"), for: .normal)
            button.setImage(DesignSystemAsset.image(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .neutral900
            button.setTitleColor(.neutral900, for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
            return button
        }()

        let emptyView = DictionaryListEmptyView()

        super.init(editButton: nil, sortButton: sortButton, filterButton: filterButton, emptyView: emptyView, isFilterHidden: isFilterHidden)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
