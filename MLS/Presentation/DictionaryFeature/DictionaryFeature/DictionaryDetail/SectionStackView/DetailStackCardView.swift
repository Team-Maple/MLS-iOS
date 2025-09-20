import UIKit

import BaseFeature
import DesignSystem
import DomainInterface

import SnapKit

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
    }

    // MARK: - Components
    private let filterContainerView = UIView()
    // 몬스터 순서 필터 버튼
    public let filterButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledString(font: .btn_s_r, text: "드롭률 순", color: .textColor), for: .normal)
        button.setImage(DesignSystemAsset.image(named: "dropDown")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    private let spacer = UIView()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        // stack view들의 서브뷰들은 직접 제약사항을 잡지말고, 스택뷰로 컨트롤해야함
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16)
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
private extension DetailStackCardView {
    func addViews() {
        addArrangedSubview(filterContainerView)
        filterContainerView.addSubview(filterButton)
        addArrangedSubview(spacer)
    }

    func setUpConstraints() {
        filterContainerView.snp.makeConstraints { make in
            make.height.equalTo(Constant.filterContainerHeight)
            //make.trailing.equalToSuperview()
            //make.top.equalToSuperview().offset(Constant.filterContainerTopMargin)
        }

        filterButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constant.filterButtonTrailing)
        }

        spacer.snp.makeConstraints { make in
            make.height.equalTo(Constant.filterSpacing)
        }
    }

    func configureUI() {
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
        // 퀘스트 판별을 위한 인덱스 0: preQuest, 1: currentQuest, 2: nextQuest
        var questIndex: Int?

        init(
            type: DetailType,
            imageUrl: String,
            mainText: String?,
            subText: String? = nil,
            additionalText: String? = nil,
            questIndex: Int? = nil
        ) {
            self.type = type
            self.imageUrl = imageUrl
            self.mainText = mainText
            self.subText = subText
            self.additionalText = additionalText
            self.questIndex = questIndex
        }
    }

    func inject(input: Input) {
        // type별 필터 유무
        setFilter(isHidden: input.type.sortFilter.isEmpty)

        let cardView = CardList()
        let spacer = UIView()

        addArrangedSubview(cardView)
        addArrangedSubview(spacer)

        cardView.snp.makeConstraints { make in
            //horizontalEdges.equalToSuperview().inset(Constant.cardHorizontalInset)
        }

        spacer.snp.makeConstraints { make in
            //make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constant.viewSpacing)
        }

        cardView.setType(type: .detailStackText)
        ImageLoader.shared.loadImage(stringURL: input.imageUrl) { image in
            guard let image = image else { return }
            cardView.setImage(image: image, backgroundColor: input.type.backgroundColor)
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
            switch input.questIndex {
            case 0:
                cardView.setType(type: .detailStackBadge(.preQuest))
            case 1:
                cardView.setType(type: .detailStackBadge(.currentQuest))
            default:
                cardView.setType(type: .detailStackBadge(.nextQuest))
            }
        default:
            break
        }
    }

    func setFilter(isHidden: Bool) {
        filterContainerView.isHidden = isHidden

        spacer.snp.remakeConstraints { make in
            make.height.equalTo(isHidden ? Constant.topSpacing : Constant.filterSpacing)
        }
    }

    func selectFilter(selectedType: SortType) {
        filterButton.setAttributedTitle(.makeStyledString(font: .b_s_r, text: selectedType.rawValue, color: .primary700), for: .normal)
        filterButton.tintColor = .primary700
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
