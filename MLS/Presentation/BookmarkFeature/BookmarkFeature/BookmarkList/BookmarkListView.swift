import UIKit

import BaseFeature
import DesignSystem

final class BookmarkListView: BaseListView {
    let bookmarkEmptyView: DataEmptyView

    // MARK: - Init
    init(isFilterHidden: Bool, bookmarkEmptyView: DataEmptyView) {
        let editButton = TextButton()
        let sortButton = BaseListView.makeSortButton(title: "가나다 순", tintColor: .textColor)
        let filterButton = BaseListView.makeFilterButton(title: "필터", tintColor: .textColor)
        self.bookmarkEmptyView = bookmarkEmptyView
        super.init(
            editButton: editButton,
            sortButton: sortButton,
            filterButton: filterButton,
            emptyView: bookmarkEmptyView,
            isFilterHidden: isFilterHidden
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
