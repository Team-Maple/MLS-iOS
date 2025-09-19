import UIKit

import BaseFeature
import DesignSystem

final class BookmarkListView: BaseListView {
    // MARK: - Init
    init(isFilterHidden: Bool) {
           let editButton = TextButton()
           let sortButton = BaseListView.makeSortButton(title: "가나다 순", tintColor: .textColor)
           let filterButton = BaseListView.makeFilterButton(title: "필터", tintColor: .textColor)
           let emptyView = BookmarkEmptyView()

           super.init(
               editButton: editButton,
               sortButton: sortButton,
               filterButton: filterButton,
               emptyView: emptyView,
               isFilterHidden: isFilterHidden
           )
       }

       @available(*, unavailable)
       required init?(coder: NSCoder) { fatalError() }
}
