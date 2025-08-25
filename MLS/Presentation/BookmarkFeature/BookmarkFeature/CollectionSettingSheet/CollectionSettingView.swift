import UIKit

import DesignSystem

import SnapKit

final class CollectionSettingView: UIView {
    private enum Constant {
        static let topInset: CGFloat = 16
        static let tableViewInset: CGFloat = 14
        static let tableViewHeight: CGFloat = 284
    }

    // MARK: - Properties
    let header: Header = {
        let header = Header(style: .filter, title: "컬렉션")
        return header
    }()

    public let menuTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.separatorStyle = .none
        return view
    }()

    // MARK: - init
    init() {
        super.init(frame: .zero)

        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension CollectionSettingView {
    func addViews() {
        addSubview(header)
        addSubview(menuTableView)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.topInset)
            make.horizontalEdges.equalToSuperview()
        }

        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(Constant.tableViewInset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
