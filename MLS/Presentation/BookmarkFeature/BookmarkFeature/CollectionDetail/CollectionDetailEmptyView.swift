import UIKit

import DesignSystem

import SnapKit

final class CollectionDetailEmptyView: UIView {
    // MARK: - Type
    enum Constant {
        static let imageSize: CGFloat = 220
        static let textSpacing: CGFloat = 10
        static let buttonSpacing: CGFloat = 24
        static let buttonWidth: CGFloat = 186
    }

    // MARK: - Components
    public let imageView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "connectionError")
        return view
    }()

    private let mainLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xl_b, text: "아직 아무것도 없어요!", color: .textColor)
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_s_r, text: "북마크해서 추가해보세요.", color: .neutral600)
        label.numberOfLines = 2
        return label
    }()

    public let bookmarkButton = CommonButton(style: .normal, title: "북마크하러 가기", disabledTitle: nil)

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
private extension CollectionDetailEmptyView {
    func addViews() {
        addSubview(imageView)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(bookmarkButton)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageSize)
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.center.equalToSuperview()
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(Constant.textSpacing)
            make.centerX.equalToSuperview()
        }

        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(Constant.buttonSpacing)
            make.width.equalTo(Constant.buttonWidth)
            make.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .clearMLS
    }
}
