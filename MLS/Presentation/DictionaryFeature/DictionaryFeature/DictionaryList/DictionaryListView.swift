import UIKit

import BaseFeature
import DesignSystem

final class DictionaryListView: BaseListView {
    // MARK: - Init
    init(isFilterHidden: Bool) {
        let sortButton = BaseListView.makeSortButton(title: "가나다 순", tintColor: .neutral900)
        let filterButton = BaseListView.makeFilterButton(title: "필터", tintColor: .neutral900)
        let emptyView = DataEmptyView(type: .dictionary)

        super.init(
            editButton: nil,
            sortButton: sortButton,
            filterButton: filterButton,
            emptyView: emptyView,
            isFilterHidden: isFilterHidden
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
