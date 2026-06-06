import MLSDesignSystem
import SnapKit
import UIKit

final class CollectionSettingView: UIView {
    private enum Constant {
        static let topInset: CGFloat = 16
        static let tableViewInset: CGFloat = 14
    }

    let header: Header = {
        Header(style: .filter, title: "컬렉션")
    }()

    let menuTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.separatorStyle = .none
        return view
    }()

    init() {
        super.init(frame: .zero)
        addSubview(header)
        addSubview(menuTableView)

        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.topInset)
            make.horizontalEdges.equalToSuperview()
        }

        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(Constant.tableViewInset)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
