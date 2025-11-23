import UIKit

import SnapKit

public final class CollectionList: UIView {
    private enum Constant {
        static let imageSize: CGFloat = 36
        static let imageInset: CGFloat = 4
        static let imageSpacing: CGFloat = 4
        static let imageRadius: CGFloat = 6
        static let contentInset: CGFloat = 10
        static let labelLeadingMargin: CGFloat = 20
        static let labelTrailingMargin: CGFloat = 64
        static let iconSize: CGFloat = 24
        static let radius: CGFloat = 12
    }

    // MARK: - Components
    private lazy var imageViews: [ItemImageView] = (0 ..< 4).map { _ in
        let view = ItemImageView(
            image: nil,
            cornerRadius: Constant.imageRadius,
            inset: Constant.imageInset,
            backgroundColor: .neutral200
        )
        return view
    }

    private lazy var imageGridView: UIStackView = {
        let topRow = UIStackView(arrangedSubviews: Array(imageViews[0...1]))
        topRow.axis = .horizontal
        topRow.spacing = Constant.imageSpacing
        topRow.distribution = .fillEqually

        let bottomRow = UIStackView(arrangedSubviews: Array(imageViews[2...3]))
        bottomRow.axis = .horizontal
        bottomRow.spacing = Constant.imageSpacing
        bottomRow.distribution = .fillEqually

        let stack = UIStackView(arrangedSubviews: [topRow, bottomRow])
        stack.axis = .vertical
        stack.spacing = Constant.imageSpacing
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    private let clickIcon: UIImageView = {
        let view = UIImageView(image: .arrowForwardSmall)
        view.tintColor = .black
        return view
    }()

    // MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
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
private extension CollectionList {
    func addViews() {
        addSubview(imageGridView)
        addSubview(textStackView)
        addSubview(clickIcon)
    }

    func setupConstraints() {
        imageGridView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constant.contentInset)
            make.verticalEdges.equalToSuperview().inset(Constant.contentInset)
            make.width.height.equalTo((Constant.imageSize * 2) + Constant.imageSpacing)
        }

        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(imageGridView.snp.trailing).offset(Constant.labelLeadingMargin)
            make.centerY.equalToSuperview()
        }

        clickIcon.snp.makeConstraints { make in
            make.leading.equalTo(textStackView.snp.trailing).offset(Constant.labelTrailingMargin)
            make.trailing.equalToSuperview().inset(Constant.contentInset)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Constant.iconSize)
        }

        imageViews.forEach {
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(Constant.imageSize)
            }
        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
        layer.cornerRadius = Constant.radius
        clipsToBounds = true
    }
}

public extension CollectionList {
    func setTitle(text: String) {
        titleLabel.attributedText = .makeStyledString(font: .b_s_m, text: text, alignment: .left)
    }

    func setSubtitle(text: String) {
        subtitleLabel.attributedText = .makeStyledString(font: .cp_xs_r, text: text, color: .neutral500, alignment: .left)
    }

    func setImages(images: [UIImage?]) {
        for (index, view) in imageViews.enumerated() {
            let imageView = view.subviews.compactMap { $0 as? UIImageView }.first
            print("이미지 뷰 설정")
            imageView?.image = index < images.count ? images[index] : nil
        }
    }
}
