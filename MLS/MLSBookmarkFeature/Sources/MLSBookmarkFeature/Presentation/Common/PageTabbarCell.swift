import MLSDesignSystem
import SnapKit
import UIKit

final class PageTabbarCell: UICollectionViewCell {
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
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? .sub_m_b : .b_m_r
            titleLabel.textColor = isSelected ? .textColor : .neutral600
        }
    }

    func inject(title: String?) {
        titleLabel.text = title
    }
}
