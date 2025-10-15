import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

final class NotificationItemView: UIView {
    // MARK: - Constants
    enum Constant {
        static let iconInset: CGFloat = 10
        static let buttonSize: CGFloat = 44
        static let topMargin: CGFloat = 20
        static let viewHeight: CGFloat = 100
        static let subTextViewWidth: CGFloat = 220
        static let horizontalMargin: CGFloat = 16
        static let subTextTopMargin: CGFloat = 8
        static let spacerHeight: CGFloat = 10
    }

    // MARK: - Components
    private let titleLabel = UILabel()
    private let subTextLabel = UILabel()
    public let switchButton = UISwitch()
    public let changeButton = UIButton()
    private let spacer = UIView()

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(title: String, subtitle: String, isAuth: Bool) {
        super.init(frame: .zero)
        setupUI(title: title, subtitle: subtitle, isAuth: isAuth)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI(title: String, subtitle: String, isAuth: Bool) {
        // 기본 속성 설정
        titleLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: title, color: .textColor)
        titleLabel.textAlignment = .left

        subTextLabel.attributedText = .makeStyledString(font: .cp_s_r, text: subtitle, color: .neutral500)
        subTextLabel.numberOfLines = 0
        subTextLabel.textAlignment = .left

        switchButton.onTintColor = .primary700

        changeButton.setAttributedTitle(
            .makeStyledString(font: .cp_xs_r, text: "변경하기", color: .primary700),
            for: .normal
        )
        changeButton.semanticContentAttribute = .forceRightToLeft
        changeButton.setImage(DesignSystemAsset.image(named: "arrowForwardSmall")?.withRenderingMode(.alwaysTemplate), for: .normal)
        changeButton.tintColor = .primary700

        // addSubviews
        addSubview(titleLabel)
        addSubview(subTextLabel)
        addSubview(spacer)
        spacer.backgroundColor = .neutral100

        if isAuth {
            addSubview(switchButton)
        } else {
            addSubview(changeButton)
        }

        // Layout
        self.snp.makeConstraints { make in
            make.height.equalTo(Constant.viewHeight)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(Constant.horizontalMargin)
        }

        subTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.subTextTopMargin)
            make.leading.equalToSuperview().inset(Constant.horizontalMargin)
            make.width.equalTo(Constant.subTextViewWidth)
        }

        if isAuth {
            switchButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(Constant.horizontalMargin)
                make.top.equalToSuperview().offset(Constant.topMargin)
            }
        } else {
            changeButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(Constant.horizontalMargin)
                make.top.equalToSuperview().offset(Constant.topMargin)
            }
        }
        spacer.snp.makeConstraints { make in
            make.height.equalTo(Constant.spacerHeight)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
