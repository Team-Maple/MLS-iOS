import UIKit

import DesignSystem

import SnapKit

public final class BookmarkOnBoardingView: UIView {
    // MARK: - Type
    public enum OnBoardingIndexType: Int {
        case first = 0
        case second
        case end

        var content: OnboardingContent? {
            switch self {
            case .first:
                return .init(
                    imageName: "onBoardingBookmark",
                    title: "내가 찜한 정보, 한곳에!",
                    description: "아이템, 몬스터, 맵, NPC, 퀘스트를\n북마크하면 자동으로 여기에 모여요.",
                    isBackButtonHidden: true,
                    buttonTitle: "다음"
                )
            case .second:
                return .init(
                    imageName: "addToCollection",
                    title: "나만의 컬렉션 만들기",
                    description: "북마크한 정보들을 폴더로 정리해보세요.",
                    isBackButtonHidden: false,
                    buttonTitle: "북마크 열기"
                )
            default:
                return nil
            }
        }

        func next() -> Self {
            switch self {
            case .first: return .second
            case .second: return .end
            case .end: return .end
            }
        }

        func previous() -> Self {
            switch self {
            case .first: return .first
            case .second: return .first
            case .end: return .second
            }
        }
    }

    struct OnboardingContent {
        let imageName: String
        let title: String
        let description: String
        let isBackButtonHidden: Bool
        let buttonTitle: String
    }

    enum Constant {
        static let imageSize: CGFloat = 220
        static let imageSpacing: CGFloat = 4
        static let labelSpacing: CGFloat = 16
        static let indicatorSpacing: CGFloat = 29
        static let bottomInset: CGFloat = 16
        static let horizontalMargin: CGFloat = 16
        static let backButtonTrailing: CGFloat = -28
        static let backButtonBottom: CGFloat = 10
        static let backButtonSize: CGFloat = 24
        static let imageYOffset: CGFloat = -116
    }

    // MARK: - Components
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()

    public let backButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "arrowBack"), for: .normal)
        return button
    }()

    private let stepIndicator = StepIndicator(circleCount: 2)

    public let nextButton = CommonButton(style: .normal, title: "다음", disabledTitle: nil)

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI(type: .first)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension BookmarkOnBoardingView {
    func addViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(backButton)
        addSubview(stepIndicator)
        addSubview(nextButton)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Constant.imageYOffset)
            make.size.equalTo(Constant.imageSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constant.imageSpacing)
            make.centerX.equalToSuperview()
        }

        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.labelSpacing)
            make.centerX.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.trailing.equalTo(imageView.snp.leading).inset(Constant.backButtonTrailing)
            make.bottom.equalTo(imageView.snp.bottom).inset(Constant.backButtonBottom)
        }

        stepIndicator.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(Constant.indicatorSpacing)
            make.centerX.equalToSuperview()
        }

        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
            make.bottom.equalToSuperview().inset(Constant.bottomInset)
        }
    }
}

public extension BookmarkOnBoardingView {
    func configureUI(type: OnBoardingIndexType) {
        guard let content = type.content else { return }
        imageView.image = DesignSystemAsset.image(named: content.imageName)
        titleLabel.attributedText = .makeStyledString(font: .h_xxxl_b, text: content.title)
        descLabel.attributedText = .makeStyledString(font: .b_m_r, text: content.description, color: .neutral700)
        nextButton.updateTitle(title: content.buttonTitle)
        backButton.isHidden = content.isBackButtonHidden
        stepIndicator.selectIndicator(index: type.rawValue)
    }
}
