import UIKit

import DesignSystem

import SnapKit

final class NotificationEmptyView: UIView {
    // MARK: - Type
    enum Constant {
        static let imageViewSize: CGFloat = 220
        static let spacing: CGFloat = 12
    }

    // MARK: - Components
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "settingsHint")
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xl_b, text: "알림이 꺼져있어요", alignment: .center)
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()

        let fullText = "오른쪽 상단 설정을 눌러 알림을 켜면\n업데이트, 이벤트 소식을 바로 받아볼 수 있어요!"
        let keyword = "설정"

        guard let baseFont = UIFont.cp_s_r,
              let specialFont = UIFont.cp_s_r else { return UILabel() }
        let specialColor = UIColor.textColor
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.maximumLineHeight = (baseFont.lineHeight) * 1.17

        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: baseFont,
                .foregroundColor: UIColor.neutral600,
                .paragraphStyle: paragraphStyle
            ]
        )

        if let range = fullText.range(of: keyword) {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttributes([
//                .font: specialFont,
                .foregroundColor: specialColor
            ], range: nsRange)
        }

        label.attributedText = attributedText
        label.numberOfLines = 0
        return label
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
private extension NotificationEmptyView {
    func addViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subLabel)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageViewSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constant.spacing)
            make.centerX.equalToSuperview()
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.spacing)
            make.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .clearMLS
    }
}
