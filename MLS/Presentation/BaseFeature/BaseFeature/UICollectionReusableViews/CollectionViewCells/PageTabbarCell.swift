import UIKit

import DesignSystem

import SnapKit

public class PageTabbarCell: UICollectionViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .b_m_r
        label.textColor = .neutral600
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var isSelected: Bool {
        didSet {
            let font: UIFont? = isSelected ? .sub_m_b : .b_m_r
            let textColor: UIColor? = isSelected ? .textColor : .neutral600
            titleLabel.font = font
            titleLabel.textColor = textColor
        }
    }
}

// MARK: - SetUp
private extension PageTabbarCell {
    func addViews() {
        contentView.addSubview(titleLabel)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    func configureUI() { }
}

public extension PageTabbarCell {
    func inject(title: String?) {
        titleLabel.text = title
    }
}
