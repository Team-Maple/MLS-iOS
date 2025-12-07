import BaseFeature
import DesignSystem
import DomainInterface
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import UIKit

final class DetailStackCardView: UIStackView {
    // MARK: - Type
    private enum Constant {
        static let topSpacing: CGFloat = 20
        static let filterSpacing: CGFloat = 12
        static let cardHorizontalInset: CGFloat = 16
        static let filterContainerHeight: CGFloat = 28
        static let filterContainerTopMargin: CGFloat = 12
        static let filterButtonTrailing: CGFloat = 8
        static let viewSpacing: CGFloat = 10
        static let stackViewInset: UIEdgeInsets = .init(
            top: 12,
            left: 16,
            bottom: 0,
            right: 16
        )
    }

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    private let tapSubject = PublishSubject<Int>()
    var tap: Observable<Int> { tapSubject.asObservable() }

    // MARK: - Components
    private var cardViews: [CardList] = []

    private let filterContainerView = UIView()
    // 몬스터 순서 필터 버튼
    public let filterButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            .makeStyledString(
                font: .b_s_r,
                text: "드롭률 높은 순",
                color: .textColor
            ),
            for: .normal
        )
        button.setImage(
            DesignSystemAsset.image(named: "dropDown")?.withRenderingMode(
                .alwaysTemplate
            ),
            for: .normal
        )

        button.tintColor = .textColor
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    private let spacer = UIView()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = Constant.stackViewInset

        addViews()
        setUpConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
extension DetailStackCardView {
    fileprivate func addViews() {
        addArrangedSubview(filterContainerView)
        filterContainerView.addSubview(filterButton)
        addArrangedSubview(spacer)
    }

    fileprivate func setUpConstraints() {
        filterContainerView.snp.makeConstraints { make in
            make.height.equalTo(Constant.filterContainerHeight)
        }

        filterButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(
                Constant.filterButtonTrailing
            )
        }

        spacer.snp.makeConstraints { make in
            make.height.equalTo(Constant.filterSpacing)
        }
    }

    fileprivate func configureUI() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
    }
}

// MARK: - Methods
extension DetailStackCardView {
    struct Input {
        let type: DetailType
        let imageUrl: String
        // 왼쪽 텍스트
        let mainText: String?
        var subText: String?
        // 오른쪽 텍스트
        var additionalText: String?
        var questType: QuestDictionaryDetailReactor.QuestType?

        init(
            type: DetailType,
            imageUrl: String,
            mainText: String?,
            subText: String? = nil,
            additionalText: String? = nil,
            questType: QuestDictionaryDetailReactor.QuestType? = nil
        ) {
            self.type = type
            self.imageUrl = imageUrl
            self.mainText = mainText
            self.subText = subText
            self.additionalText = additionalText
            self.questType = questType
        }
    }

    func inject(input: Input) {
        // type별 필터 유무
        setFilter(isHidden: input.type.sortFilter.isEmpty)
        let cardView = CardList()
        cardViews.append(cardView)
        let spacer = UIView()

        addArrangedSubview(cardView)
        addArrangedSubview(spacer)

        spacer.snp.makeConstraints { make in
            make.height.equalTo(Constant.viewSpacing)
        }

        cardView.setType(type: .detailStackText)
        ImageLoader.shared.loadImage(stringURL: input.imageUrl) { image in
            guard let image = image else { return }
            if input.type == .appearMap || input.type == .appearMapWithText {
                cardView.setMapImage(
                    image: image,
                    backgroundColor: input.type.backgroundColor
                )
            } else {
                cardView.setImage(
                    image: image,
                    backgroundColor: input.type.backgroundColor
                )
            }
        }
        cardView.mainText = input.mainText
        cardView.subText = input.subText

        switch input.type {
        case .dropItemWithText, .dropMonsterWithText:
            cardView.setType(type: .detailStackText)
            cardView.setDropInfoText(title: "드롭률", value: input.additionalText)
        case .appearMonsterWithText, .appearMapWithText:
            cardView.setType(type: .detailStackText)
            cardView.setDropInfoText(title: "출현수", value: input.additionalText)
        case .appearMap, .appearNPC, .quest:
            cardView.setType(type: .detailStack)
        case .linkedQuest:
            switch input.questType {
            case .previous:
                cardView.setType(type: .detailStackBadge(.preQuest))
            case .current:
                cardView.setType(type: .detailStackBadge(.currentQuest))
            default:
                cardView.setType(type: .detailStackBadge(.nextQuest))
            }
        default:
            break
        }

        cardView.rx.tapGesture()
            .when(.recognized)
            .map { [weak self] _ -> Int in
                guard let self = self else { return 0 }
                return self.cardViews.firstIndex(of: cardView) ?? 0
            }
            .bind(to: tapSubject)
            .disposed(by: disposeBag)
    }

    func setFilter(isHidden: Bool) {
        filterContainerView.isHidden = isHidden

        spacer.snp.remakeConstraints { make in
            make.height.equalTo(
                isHidden ? Constant.topSpacing : Constant.filterSpacing
            )
        }
    }

    func selectFilter(selectedType: SortType) {
        filterButton.setAttributedTitle(
            .makeStyledString(
                font: .b_s_r,
                text: selectedType.rawValue,
                color: .primary700
            ),
            for: .normal
        )
        filterButton.tintColor = .primary700
    }

    func initFilter(firstFilter: SortType) {
        filterButton.setAttributedTitle(
            .makeStyledString(
                font: .b_s_r,
                text: firstFilter.rawValue,
                color: .textColor
            ),
            for: .normal
        )
    }

    func reset() {
        cardViews.removeAll()
        // 필터 뷰를 제외한 arrangedSubview만 제거
        for subview in arrangedSubviews {
            if subview == filterContainerView { continue }
            if subview == spacer { continue }

            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}

extension DetailType {
    var backgroundColor: UIColor {
        switch self {
        case .appearMap, .appearMapWithText:
            .listMap
        case .appearMonsterWithText, .dropMonsterWithText:
            .listMonster
        case .appearNPC:
            .listNPC
        case .dropItemWithText:
            .listItem
        case .linkedQuest, .quest:
            .listQuest
        case .normal, .mapInfo:
            .clearMLS
        }
    }
}
