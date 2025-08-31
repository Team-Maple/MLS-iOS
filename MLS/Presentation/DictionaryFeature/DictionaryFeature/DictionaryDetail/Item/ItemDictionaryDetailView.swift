import UIKit

import DesignSystem

final class ItemDictionaryDetailView: UIView {
    // MARK: - Type
    enum Constant {
        static let descriptionCornerRadius: CGFloat = 16
        static let descriptionStackViewInset: UIEdgeInsets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        static let descriptionStackViewHeight: CGFloat = 50
        static let horizontalInset: CGFloat = 10
        static let dividerHeight: CGFloat = 1
        static let detailInfoStackViewInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        static let detailInfoStackViewSpacing: CGFloat = 20
        static let detailDropMonsterStackViewSpacing: CGFloat = 12
        static let filterContainerViewHeight: CGFloat = 28
        static let filterContainerViewTopMargin: CGFloat = 12
        static let filterButtonTrailingMargin: CGFloat = 8
        static let cardViewHorizontalInset: CGFloat = 16
    }
    // 상세정보 뷰 안에 들어갈 스택뷰
    public let detailInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Constant.detailInfoStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.detailInfoStackViewInset
        return stackView
    }()
    // 상세정보 스택 뷰 속 설명 글
    public let detailInfoDescriptionText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = .makeStyledString(font: .b_s_r, text: "강철로 만든 수리검이다. 여러개가 들어있으며 모두 사용했다면 다시 충전해야 한다.강철로 만든 수리검이다. 여러개가 들어있으며 모두 사용했다면 다시 충전해야 한다.강철로 만든 수리검이다. 여러개가 들어있으며 모두 사용했다면 다시 충전해야 한다.")
        label.textAlignment = .left
        return label
    }()
    // 상세정보 스택 뷰 속 아이템 정보 보여주는 스택뷰(물공 - 2, 판매가 - 1메소)
    public let detailInfoItemInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .whiteMLS
        stackView.distribution = .fill
        stackView.layer.cornerRadius = Constant.descriptionCornerRadius
        return stackView
    }()
    public let detailDropMonsterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Constant.detailDropMonsterStackViewSpacing
        return stackView
    }()
    // 몬스터 순서 필터 버튼
    public let filterButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledString(font: .btn_s_r, text: "드롭률 순", color: .textColor), for: .normal)
        button.setImage(DesignSystemAsset.image(named: "dropDown"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    // 몬스터 순서 필터 담을 뷰 -> 버튼을 스택뷰에 바로 올려놓으면 제약사항 잡기가 힘듬..
    public let filterContainerView = UIView()

    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension ItemDictionaryDetailView {
    func addViews() {
        addSubview(detailInfoStackView)
        addSubview(detailDropMonsterStackView)

        detailInfoStackView.addArrangedSubview(detailInfoDescriptionText)
        detailInfoStackView.addArrangedSubview(detailInfoItemInfoStackView)

        detailDropMonsterStackView.addArrangedSubview(filterContainerView)

        filterContainerView.addSubview(filterButton)

    }

    func setupConstraints() {
        detailInfoStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        detailDropMonsterStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        filterContainerView.snp.makeConstraints { make in
            make.height.equalTo(Constant.filterContainerViewHeight)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(Constant.filterContainerViewTopMargin)
        }

        filterButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constant.filterButtonTrailingMargin)
        }
    }
    // 아이템 정보 보여주는 스택뷰 생성
    func detailDesctiptionItemStackViewSetup() -> UIStackView {
        let stackView = UIStackView()
        let dividerView = DividerView()
        // 가로 스택 뷰
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing // 좌우 label 사이 간격 고르게
        stackView.alignment = .center
        // 내부 패딩값 주기
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.descriptionStackViewInset

        detailInfoItemInfoStackView.addArrangedSubview(stackView)
        detailInfoItemInfoStackView.addArrangedSubview(dividerView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.descriptionStackViewHeight)
        }

        dividerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.dividerHeight)
        }
        return stackView
    }
    // 아이템 상세 설명에 들어갈 텍스트 스택뷰 만들기
    func makeItemDetailDescriptionTextStackView(stackView: UIStackView, mainText: String, subText: String) {
        let mainLabel = UILabel()
        mainLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: mainText)

        let subLabel = UILabel()
        subLabel.attributedText = .makeStyledString(font: .b_s_r, text: subText)
        stackView.addArrangedSubview(mainLabel)
        stackView.addArrangedSubview(subLabel)
    }

    // 드롭 몬스터 뷰 생성
    func dropMonsterViewSetup() {
        // 뷰 전용 매개변수 데이터 구조체가 필요할 듯
        // 이름, 레벨, 드롭률, 이미지 등의 정보를 받아야 할듯
        // 이 부분 좀만 더 생각해보기
        let cardView = CardList()
        cardView.setType(type: .dropInfo)
        cardView.setImage(image: DesignSystemAsset.image(named: "testImage")!, backgroundColor: .listMonster)
        cardView.mainText = "여신 탑의 러스터 픽시"
        cardView.subText = "Lv. 99"
        cardView.setDropInfoText(title: "드롭률", value: "0.001%")

        detailDropMonsterStackView.addArrangedSubview(cardView)

        cardView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.cardViewHorizontalInset)
        }
    }
}
