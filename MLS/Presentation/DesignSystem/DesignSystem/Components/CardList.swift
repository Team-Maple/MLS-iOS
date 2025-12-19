import UIKit

import SnapKit

public final class CardList: UIView {
    // MARK: - Type
    public enum CardListType {
        case bookmark
        case checkbox
        case detailStack
        case detailStackText // 몬스터 카드일 경우 드롭률
        case detailStackBadge(Badge.BadgeStyle)

        var icon: UIImage? {
            switch self {
            case .bookmark:
                return .bookmarkBorderList
            case .checkbox:
                return .checkSquare
            case .detailStack, .detailStackText, .detailStackBadge:
                return nil
            }
        }

        var selectedIcon: UIImage? {
            switch self {
            case .bookmark:
                return .bookmarkList
            case .checkbox:
                return .checkSquareFill
            case .detailStack, .detailStackText, .detailStackBadge:
                return nil
            }
        }
    }

    enum Constant {
        static let cardRadius: CGFloat = 16
        static let cardLeadingInset: CGFloat = 12
        static let cardTrailingInset: CGFloat = 16
        static let infoLabelInset: CGFloat = 16
        static let imageRadius: CGFloat = 8
        static let imageInset: CGFloat = 10
        static let imageContentViewSize: CGFloat = 80
        static let stackViewSpacing: CGFloat = 4
        static let iconSize: CGFloat = 24
        static let mapImageSize: CGFloat = 40
    }

    // MARK: - Properties
    private var type = CardListType.bookmark
    private var icon = UIImage()
    private var selectedIcon = UIImage()

    public var isIconSelected: Bool = false {
        didSet {
            updateIcon()
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

    public var onIconTapped: (() -> Void)?

    // MARK: - Components
    public let imageView = ItemImageView(image: nil, cornerRadius: Constant.imageRadius, inset: Constant.imageInset, backgroundColor: .listMap)

    private lazy var textLabelStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mainTextLabel, subTextLabel])
        view.axis = .vertical
        view.spacing = Constant.stackViewSpacing
        return view
    }()

    private let mainTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.lineBreakStrategy = .pushOut
        return label
    }()

    private let subTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let iconButton: UIButton = {
        let button = UIButton()
        button.setImage(.bookmarkBorder, for: .normal)
        return button
    }()

    // 드롭률 표시용 라벨 2개
    private let dropTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private let dropValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    // 2개 라벨을 세로로 묶는 스택뷰
    private lazy var dropInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dropTitleLabel, dropValueLabel])
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.isHidden = true // 기본은 숨김
        return stack
    }()

    private let badge = Badge(style: .currentQuest)

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
        addSubview(iconButton)
        addSubview(dropInfoStack)
        addSubview(badge)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Constant.cardLeadingInset)
            make.size.equalTo(Constant.imageContentViewSize)
        }

        textLabelStackView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(Constant.cardLeadingInset)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().inset(Constant.cardTrailingInset)
        }

        dropInfoStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constant.cardTrailingInset)
        }

        badge.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constant.cardTrailingInset)
        }

        iconButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constant.cardTrailingInset)
            make.size.equalTo(Constant.iconSize)
        }

        textLabelStackView.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualTo(dropInfoStack.snp.leading).offset(-Constant.cardLeadingInset)
            make.trailing.lessThanOrEqualTo(badge.snp.leading).offset(-Constant.cardLeadingInset)
            make.trailing.lessThanOrEqualTo(iconButton.snp.leading).offset(-Constant.cardLeadingInset)
        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
        layer.cornerRadius = Constant.cardRadius
    }

    func bindButton() {
        iconButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.onIconTapped?()
        }), for: .touchUpInside)
    }

    func updateMainText() {
        mainTextLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: mainText, alignment: .left)
    }

    func updateSubText() {
        subTextLabel.attributedText = .makeStyledString(font: .cp_s_r, text: subText, color: .neutral500, alignment: .left)
    }

    func updateIcon() {
        iconButton.setImage(isIconSelected ? selectedIcon : icon, for: .normal)
    }
}

public extension CardList {
    func setMainText(text: String) {
        mainText = text
    }

    func setSubText(text: String?) {
        subText = text
    }

    func setImage(image: UIImage, backgroundColor: UIColor) {
        imageView.setImage(image: image, backgroundColor: backgroundColor)
    }

    func setMapImage(image: UIImage, backgroundColor: UIColor) {
        imageView.setMapImage(image: image, backgroundColor: backgroundColor)
    }

    func setSelected(isSelected: Bool) {
        isIconSelected = isSelected
    }

    func setType(type: CardListType) {
        self.type = type
        icon = type.icon ?? UIImage()
        selectedIcon = type.selectedIcon ?? UIImage()

        switch type {
        case .detailStack:
            iconButton.isHidden = true
            dropInfoStack.isHidden = true
            badge.isHidden = true
        case .detailStackText:
            iconButton.isHidden = true
            dropInfoStack.isHidden = false
            badge.isHidden = true
        case .detailStackBadge(let type):
            iconButton.isHidden = true
            dropInfoStack.isHidden = false
            badge.isHidden = false
            badge.update(style: type)
        default:
            iconButton.isHidden = false
            dropInfoStack.isHidden = true
            badge.isHidden = true
        }
    }

    func setDropInfoText(title: String, value: String?) {
        dropTitleLabel.attributedText = .makeStyledString(font: .cp_s_r, text: title, color: .neutral700)
        dropValueLabel.attributedText = .makeStyledString(font: .sub_m_b, text: value, color: .primary700)
    }
}
