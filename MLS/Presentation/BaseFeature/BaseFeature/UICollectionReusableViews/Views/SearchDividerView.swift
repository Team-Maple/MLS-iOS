import UIKit

import DesignSystem

import SnapKit

final public class SearchDividerView: UICollectionReusableView {
    let view: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral100
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addViews() {
        addSubview(view)
    }

    func setupConstraints() {
        view.snp.makeConstraints { make in
            make.centerY.horizontalEdges.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}
