import UIKit

import DesignSystem

import RxSwift
import SnapKit

public class DictionaryNotificationCell: UICollectionViewCell {
    // MARK: - Type
    private enum Constant {
        static let inset: CGFloat = 20
        static let spacing: CGFloat = 4
        static let radius: CGFloat = 8
        static let iconSize: CGFloat = 8
        static let iconMargin: CGFloat = 12
    }

    // MARK: - Components
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let checkIcon: UIView = {
        let view = UIView()
        view.backgroundColor = .primary700
        view.layer.cornerRadius = Constant.iconSize / 2
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
    }

    public var disposeBag = DisposeBag()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictionaryNotificationCell {
    func addViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(checkIcon)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.inset)
            make.horizontalEdges.equalToSuperview().inset(Constant.inset)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.spacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.inset)
            make.bottom.equalToSuperview().inset(Constant.inset)
        }

        checkIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constant.iconMargin)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constant.iconSize)
        }
    }
}

public extension DictionaryNotificationCell {
    struct Input {
        let title: String
        let subTitle: String
        let isChecked: Bool

        public init(title: String, subTitle: String, isChecked: Bool) {
            self.title = title
            self.subTitle = subTitle
            self.isChecked = isChecked
        }
    }

    func inject(input: Input) {
        titleLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: input.title, color: input.isChecked ? .neutral500 : .textColor, alignment: .left)
        subTitleLabel.attributedText = .makeStyledString(font: .b_s_r, text: input.subTitle, color: input.isChecked ? .neutral500 : .neutral700, alignment: .left)
        backgroundColor = input.isChecked ? .neutral100 : .clearMLS
        layer.cornerRadius = input.isChecked ? Constant.radius : 0
        checkIcon.isHidden = !input.isChecked
    }
}
