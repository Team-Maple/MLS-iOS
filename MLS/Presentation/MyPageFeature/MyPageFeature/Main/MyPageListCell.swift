import UIKit

import DesignSystem

import SnapKit

public final class MyPageListCell: UICollectionViewCell {
    // MARK: - Type
    enum Constant {
        static let inset: CGFloat = 10
        static let badgeMargin: CGFloat = 12
    }

    // MARK: - Components
    private let titleLabel = UILabel()

    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "arrowForwardSmall")
        return view
    }()

    var levelBadge: Badge?

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
        setupContstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension MyPageListCell {
    func addViews() {
        addSubview(titleLabel)
        addSubview(iconView)
    }

    func setupContstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constant.inset)
            make.centerY.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constant.inset)
            make.centerY.equalToSuperview()
        }
    }
}

public extension MyPageListCell {
    struct Input {
        let title: String
        var isHeader: Bool
        var addLevel: Int?

        init(title: String, isHeader: Bool = false, addLevel: Int? = nil) {
            self.title = title
            self.isHeader = isHeader
            self.addLevel = addLevel
        }
    }

    func inject(input: Input) {
        titleLabel.attributedText = .makeStyledString(font: input.isHeader ? .sub_m_b : .b_m_r, text: input.title, alignment: .left)
        iconView.isHidden = input.isHeader
        levelBadge?.removeFromSuperview()
        if let level = input.addLevel {
            let levelBadge = Badge(style: .element("Lv.\(level)"))

            addSubview(levelBadge)

            levelBadge.snp.makeConstraints { make in
                make.leading.equalTo(titleLabel.snp.trailing).offset(Constant.badgeMargin)
                make.centerY.equalToSuperview()
            }
            self.levelBadge = levelBadge
        }
    }
}
