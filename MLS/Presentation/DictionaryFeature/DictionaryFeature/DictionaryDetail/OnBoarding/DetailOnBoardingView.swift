import UIKit

import DesignSystem
import DomainInterface

import SnapKit

class DetailOnBoardingView: UIView {
    // MARK: - Type
    public enum Constant {
        static let margin: CGFloat = 48
        static let trailingMargin: CGFloat = 8
        static let iconSize: CGFloat = 36
        static let contentViewSize: CGFloat = 44
        static let arrowSize: CGFloat = 48
        static let arrowTrailing: CGFloat = 28
        static let arrowMargin: CGFloat = 6
        static let alertHeight: CGFloat = 220
        static let alertWidth: CGFloat = 328
        static let buttonWitdh: CGFloat = 96
        static let radius: CGFloat = 8
    }

    // MARK: - Components
    private lazy var iconContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteMLS
        view.layer.cornerRadius = Constant.radius

        view.addSubview(iconView)

        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constant.iconSize)
        }

        return view
    }()

    private let iconView: UIImageView = {
        let view = UIImageView(image: DesignSystemAsset.image(named: "guideIcon"))
        return view
    }()

    private let firstArrow: UIImageView = {
        let view = UIImageView(image: DesignSystemAsset.image(named: "guideArrow1"))
        return view
    }()

    private let secondArrow: UIImageView = {
        let view = UIImageView(image: DesignSystemAsset.image(named: "guideArrow2"))
        return view
    }()

    private let firstLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0

        let text = "해당 내용에 잘못된 정보가 있다면\n아이콘을 눌러 제보할 수 있어요."
        guard let font = UIFont.korFont(style: .bold, size: 16) else { return UILabel() }
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.whiteMLS,
                .font: font
            ]
        )

        let highlights = ["잘못된 정보", "아이콘을 눌러 제보"]

        highlights.forEach { keyword in
            if let range = text.range(of: keyword) {
                attributedString.addAttribute(
                    .foregroundColor,
                    value: UIColor.secondary,
                    range: NSRange(range, in: text)
                )
            }
        }

        label.attributedText = attributedString
        return label
    }()

    private let secondLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0

        let text = "제보해주시면 빠르게 반영 할게요!"
        guard let font = UIFont.korFont(style: .bold, size: 16) else { return UILabel() }
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.whiteMLS,
                .font: font
            ]
        )

        if let range = text.range(of: "빠르게 반영") {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.secondary, range: nsRange)
        }

        label.attributedText = attributedString
        return label
    }()

    private let alertView: UIImageView = {
        let view = UIImageView(image: DesignSystemAsset.image(named: "guideAlert"))
        return view
    }()

    public let closeButton: CommonButton = {
        let button = CommonButton(style: .border, title: "닫기", disabledTitle: nil)
        button.updateTitleColor(color: .whiteMLS)
        return button
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DetailOnBoardingView {
    func addViews() {
        addSubview(iconContentView)
        addSubview(firstArrow)
        addSubview(secondArrow)
        addSubview(firstLabel)
        addSubview(secondLabel)
        addSubview(alertView)
        addSubview(closeButton)
    }

    func setupConstraints() {
        iconContentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(firstArrow.snp.trailing)
            make.trailing.equalToSuperview().inset(Constant.trailingMargin)
            make.size.equalTo(Constant.contentViewSize)
        }

        firstArrow.snp.makeConstraints { make in
            make.top.equalTo(iconContentView.snp.centerY)
            make.size.equalTo(Constant.arrowSize)
        }

        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(firstArrow.snp.bottom)
            make.trailing.equalToSuperview().inset(Constant.trailingMargin)
        }

        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(Constant.alertWidth)
            make.height.equalTo(Constant.alertHeight)
        }

        secondArrow.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.bottom).offset(Constant.arrowMargin)
            make.centerX.equalTo(firstLabel)
            make.size.equalTo(Constant.arrowSize)
        }

        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(secondArrow.snp.bottom).offset(Constant.arrowMargin)
            make.trailing.equalTo(secondArrow.snp.trailing).offset(Constant.arrowTrailing)
        }

        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constant.margin)
            make.width.equalTo(Constant.buttonWitdh)
        }
    }

    func configureUI() {
        backgroundColor = .clearMLS
    }
}

extension DetailOnBoardingView {}
