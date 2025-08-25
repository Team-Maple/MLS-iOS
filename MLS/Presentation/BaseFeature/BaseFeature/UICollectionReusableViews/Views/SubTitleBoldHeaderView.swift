import UIKit

import DesignSystem

import SnapKit

final public class SubTitleBoldHeaderView: UICollectionReusableView {

    private let headerLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension SubTitleBoldHeaderView {
    func addViews() {
        addSubview(headerLabel)
    }

    func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

public extension SubTitleBoldHeaderView {
    func inject(title: String?) {
        headerLabel.attributedText = .makeStyledString(font: .sub_m_b, text: title, alignment: .left)
    }
}
