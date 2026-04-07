import UIKit

import SnapKit

public final class ToLoginView: UIView {
    // MARK: - Type
    enum Constant {
        static let imageSize: CGFloat = 220
        static let textSpacing: CGFloat = 10
        static let buttonSpacing: CGFloat = 24
        static let buttonWidth: CGFloat = 186
    }

    // MARK: - Components
    public let imageView = UIImageView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()

    public let button = CommonButton()

    // MARK: - Init
    public init(mainText: String, subText: String, buttonText: String? = nil) {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI(mainText: mainText, subText: subText, buttonText: buttonText)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension ToLoginView {
    func addViews() {
        addSubview(imageView)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(button)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageSize)
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(Constant.textSpacing)
            make.centerX.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(Constant.buttonSpacing)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constant.buttonWidth)
        }
    }

    func configureUI(mainText: String, subText: String, buttonText: String? = nil) {
        backgroundColor = .neutral100
        imageView.image = DesignSystemAsset.image(named: "noShowList")
        mainLabel.attributedText = .makeStyledString(
            font: .h_xl_b,
            text: mainText
        )

        subLabel.attributedText = .makeStyledString(
            font: .cp_s_r,
            text: subText,
            color: .neutral600
        )

        button.updateTitle(title: buttonText ?? "로그인하러 가기")
    }
}
