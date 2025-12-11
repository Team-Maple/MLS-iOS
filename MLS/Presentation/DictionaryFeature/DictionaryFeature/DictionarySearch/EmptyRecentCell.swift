import UIKit

import SnapKit

final class EmptyRecentCell: UICollectionViewCell {
    private let label: UILabel = {
       let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_s_r, text: "최근 검색어 내역이 없습니다", color: .neutral600)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setUpConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: SetUp
private extension EmptyRecentCell {
    func addViews() {
        contentView.addSubview(label)
    }

    func setUpConstraints() {
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(32)
        }

    }
}
