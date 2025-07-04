import UIKit

import SnapKit

public final class CardList: UIView {
    // MARK: - Type
    enum Constant {
        static let cardRadius: CGFloat = 16
        static let cardInset: CGFloat = 12
        static let imageRadius: CGFloat = 8
        static let imageInset: CGFloat = 10
        static let imageContentViewSize: CGFloat = 80
        static let stackViewSpacing: CGFloat = 4
        static let stackViewInset: CGFloat = 6
        static let bookmarkSize: CGFloat = 24
    }

    // MARK: - Properties
    public var isBookmarkSelected: Bool = false {
        didSet {
            updateBookmark()
        }
    }

    public var mainText: String? {
        didSet {
            updateMainText()
        }
    }

    public var subText: String? {
        didSet {
            updateSubText()
        }
    }

    public var onBookmarkTapped: ((Bool) -> Void)?

    // MARK: - Components
    private let imageView = ItemImageView(image: nil, cornerRadius: Constant.imageRadius, inset: Constant.imageInset, backgroundColor: .listMap)

    private lazy var textLabelStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mainTextLabel, subTextLabel])
        view.axis = .vertical
        view.spacing = Constant.stackViewSpacing
        return view
    }()

    private let mainTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

    private let subTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(.bookmarkBorder, for: .normal)
        return button
    }()

    public init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
        bindButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension CardList {
    func addViews() {
        addSubview(imageView)
        addSubview(textLabelStackView)
        addSubview(bookmarkButton)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Constant.cardInset)
            make.size.equalTo(Constant.imageContentViewSize)
        }

        textLabelStackView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(Constant.cardInset)
            make.top.bottom.equalTo(imageView).inset(Constant.stackViewInset)
        }

        bookmarkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(textLabelStackView.snp.trailing).offset(Constant.cardInset)
            make.trailing.equalToSuperview().inset(Constant.cardInset)
            make.size.equalTo(Constant.bookmarkSize)
        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
        layer.cornerRadius = Constant.cardRadius
    }

    func bindButton() {
        bookmarkButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.onBookmarkTapped?(self.isBookmarkSelected)
        }), for: .touchUpInside)
    }

    func updateMainText() {
        mainTextLabel.attributedText = .makeStyledString(font: .subTitle, text: mainText, alignment: .left)
    }

    func updateSubText() {
        subTextLabel.attributedText = .makeStyledString(font: .caption, text: subText, color: .neutral500, alignment: .left)
    }

    func updateBookmark() {
        bookmarkButton.setImage(isBookmarkSelected ? .bookmark : .bookmarkBorder, for: .normal)
    }
}

public extension CardList {
    func setMainText(text: String) {
        mainText = text
    }

    func setSubText(text: String) {
        subText = text
    }

    func setImage(image: UIImage, backgroundColor: UIColor) {
        imageView.setImage(image: image, backgroundColor: backgroundColor)
    }

    func setBookmark(isBookmarked: Bool) {
        isBookmarkSelected = isBookmarked
    }
}
