import UIKit

import BaseFeature
import DesignSystem

final class BookmarkListView: BaseListView {
    let bookmarkEmptyView: BookmarkEmptyView

    // MARK: - Init
    init(isFilterHidden: Bool, bookmarkEmptyView: BookmarkEmptyView) {
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

extension BookmarkListView {
    func updateView(state: BookmarkListReactor.ViewState) {
        switch state {
        case .loginWithData:
            checkEmptyData(isEmpty: false)

        case .loginWithoutData:
            checkEmptyData(isEmpty: true)
            if let emptyView = emptyView as? BookmarkEmptyView {
                checkEmptyData(isEmpty: true)
                emptyView.setLabel(isLogin: true)
            }

        case .logout:
            if let emptyView = emptyView as? BookmarkEmptyView {
                checkEmptyData(isEmpty: true)
                emptyView.setLabel(isLogin: false)
            }
        }
    }
}
