import UIKit

import BaseFeature
import DesignSystem
import DomainInterface

import SnapKit

final class DetailStackCardView: UIStackView {
    // MARK: - Type
    private enum Constant {
        static let spacing: CGFloat = 20
        static let filterSpacing: CGFloat = 12
        static let cardHorizontalInset: CGFloat = 16
        static let filterContainerHeight: CGFloat = 28
        static let filterContainerTopMargin: CGFloat = 12
        static let filterButtonTrailing: CGFloat = 8
    }

    // MARK: - Components
    private let filterContainerView = UIView()
    // 몬스터 순서 필터 버튼
    public let filterButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledString(font: .btn_s_r, text: "드롭률 순", color: .textColor), for: .normal)
        button.setImage(DesignSystemAsset.image(named: "dropDown"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    let spacer = UIView()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
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
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(Constant.filterContainerTopMargin)
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
        var subText: String? = nil
        // 오른쪽 텍스트
        var additionalText: String? = nil
        // 퀘스트 판별을 위한 인덱스 0: preQuest, 1: currentQuest, 2: nextQuest
        var questIndex: Int? = nil
        
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

        addArrangedSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.cardHorizontalInset)
        }

        cardView.setType(type: .detailStackText)
        // defaultImage 변경 필요
        ImageLoader.shared.loadImage(stringURL: input.imageUrl, defaultImage: DesignSystemAsset.image(named: "testImage")) { image in
            guard let image = image else { return }
            cardView.setImage(image: image, backgroundColor: input.type.backgroundColor)
        }
        cardView.mainText = input.mainText
        cardView.subText = input.subText

        switch input.type {
        case .dropItem, .dropMonster:
            cardView.setType(type: .detailStackText)
            cardView.setDropInfoText(title: "드롭률", value: input.additionalText)
        case .appearMonster, .appearMapWithDropRate:
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
            make.height.equalTo(isHidden ? Constant.spacing : Constant.filterSpacing)
        }
    }
}

extension DetailType {
    var backgroundColor: UIColor {
        switch self {
        case .appearMap, .appearMapWithDropRate:
            .listMap
        case .appearMonster, .dropMonster:
            .listMonster
        case .appearNPC:
            .listNPC
        case .dropItem:
            .listItem
        case .linkedQuest, .quest:
            .listQuest
        case .normal, .mapInfo:
            .clearMLS
        }
    }
}
