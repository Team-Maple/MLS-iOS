import UIKit

import DesignSystem
import DomainInterface

import RxGesture
import RxSwift
import SnapKit

final class DetailStackInfoView: UIStackView {
    // MARK: - Type
    private enum Constant {
        static let descriptionCornerRadius: CGFloat = 16
        static let descriptionStackViewInset: UIEdgeInsets = .init(top: 14, left: 16, bottom: 14, right: 16)
        static let detailStackViewInset: UIEdgeInsets = .init(top: 20, left: 16, bottom: 20, right: 16)
        static let detailInfoStackViewInset: UIEdgeInsets = .init(top: 10, left: 0, bottom: 10, right: 0)
        static let height: CGFloat = 50
        static let dividerHeight: CGFloat = 1
        static let horizontalInset: CGFloat = 10
        static let detailInfoStackViewSpacing: CGFloat = 20
        static let titleLeadingInset: CGFloat = 16
    }

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - Components
    // 상세정보 스택 뷰 속 설명 글
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = .makeStyledString(font: .b_s_r, text: "강철로 만든 수리검이다. 여러개가 들어있으며 모두 사용했다면 다시 충전해야 한다.강철로 만든 수리검이다. 여러개가 들어있으며 모두 사용했다면 다시 충전해야 한다.강철로 만든 수리검이다. 여러개가 들어있으며 모두 사용했다면 다시 충전해야 한다.", color: .neutral700)
        label.textAlignment = .left
        return label
    }()

    // 상세정보 스택 뷰 속 아이템 정보 보여주는 스택뷰(물공 - 2, 판매가 - 1메소)
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .whiteMLS
        stackView.distribution = .fill
        stackView.layer.cornerRadius = Constant.descriptionCornerRadius
        return stackView
    }()

    // 퀘스트 상세정보 스택뷰 속 상세정보 스택뷰
    private let detailInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .whiteMLS
        stackView.distribution = .fill
        stackView.layer.cornerRadius = Constant.descriptionCornerRadius
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.detailInfoStackViewInset
        return stackView
    }()

    // 타이틀 뷰
    private let detailInfoTitleLabelView = UIView()
    // 타이틀 라벨
    private let detailInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_b, text: "상세 정보", color: .textColor)
        return label
    }()

    // 퀘스트 완료조건 스택뷰
    private let completeConditionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .whiteMLS
        stackView.distribution = .fill
        stackView.layer.cornerRadius = Constant.descriptionCornerRadius
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.detailInfoStackViewInset
        return stackView
    }()

    private let completeConditionTitleLabelView = UIView()
    private let completeConditionTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_b, text: "완료 조건", color: .textColor)
        return label
    }()

    // 퀘스트 보상 스택뷰
    private let rewardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .whiteMLS
        stackView.distribution = .fill
        stackView.layer.cornerRadius = Constant.descriptionCornerRadius
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.detailInfoStackViewInset
        return stackView
    }()

    private let rewardTitleLabelView = UIView()
    private let rewardTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_b, text: "보상", color: .textColor)
        return label
    }()

    // 어떤뷰 타입의 상세정보인지 구분하기 위한 변수
    private let type: DictionaryItemType

    // MARK: - Init
    init(type: DictionaryItemType) {
        self.type = type
        super.init(frame: .zero)
        configureUI()
        addViews()
        // 퀘스트일때만 제약 잡아줌
        if type == .quest {
            setConstraints()
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DetailStackInfoView {
    func addViews() {
        // DetailStackInfoView는 3가지(item, monster, quest)에서만 사용할 듯?
        if type == .item {
            // 아이템 타입일 경우만 설명라벨추가
            addArrangedSubview(descriptionLabel)
            addArrangedSubview(infoStackView)
        } else if type == .monster {
            addArrangedSubview(infoStackView)
        } else if type == .quest {
            addArrangedSubview(detailInfoStackView)
            detailInfoStackView.addArrangedSubview(detailInfoTitleLabelView)
            detailInfoTitleLabelView.addSubview(detailInfoTitleLabel)

            addArrangedSubview(completeConditionStackView)
            completeConditionStackView.addArrangedSubview(completeConditionTitleLabelView)
            completeConditionTitleLabelView.addSubview(completeConditionTitleLabel)

            addArrangedSubview(rewardStackView)
            rewardStackView.addArrangedSubview(rewardTitleLabelView)
            rewardTitleLabelView.addSubview(rewardTitleLabel)
        }
    }

    func setConstraints() {
        detailInfoTitleLabelView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.height)
        }
        detailInfoTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(Constant.titleLeadingInset)
            make.centerY.equalToSuperview()
        }
        completeConditionTitleLabelView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.height)
        }
        completeConditionTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(Constant.titleLeadingInset)
            make.centerY.equalToSuperview()
        }
        rewardTitleLabelView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.height)
        }
        rewardTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(Constant.titleLeadingInset)
            make.centerY.equalToSuperview()
        }
    }

    func configureUI() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = Constant.detailInfoStackViewSpacing
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = Constant.detailStackViewInset
    }
}

// MARK: - Methods
extension DetailStackInfoView {
    /// 퀘스트 상세정보 한 줄 추가
    func addDetailInfo(mainText: String, subText: String) {
        addInfoRow(to: detailInfoStackView, mainText: mainText, subText: subText)
    }

    /// 완료조건 상세정보 한 줄 추가
    func addCondition(mainText: String, subText: String, clickable: Bool, onTap: (() -> Void)? = nil) {
        addInfoRow(to: completeConditionStackView, mainText: mainText, subText: subText, clickable: true, onTap: onTap)
    }

    /// 보상 상세정보 한 줄 추가
    func addReward(mainText: String, subText: String) {
        addInfoRow(to: rewardStackView, mainText: mainText, subText: subText)
    }

    /// 아이템 상세정보 한 줄 추가
    func addInfo(mainText: String, subText: String) {
        addInfoRow(to: infoStackView, mainText: mainText, subText: subText)
    }

    /// 현재 표시 중인 모든 스택뷰 내용을 초기화
    func reset() {
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        detailInfoStackView.arrangedSubviews
            .filter { $0 !== detailInfoTitleLabelView }
            .forEach { $0.removeFromSuperview() }

        completeConditionStackView.arrangedSubviews
            .filter { $0 !== completeConditionTitleLabelView }
            .forEach { $0.removeFromSuperview() }

        rewardStackView.arrangedSubviews
            .filter { $0 !== rewardTitleLabelView }
            .forEach { $0.removeFromSuperview() }
    }

    private func addInfoRow(
        to stackView: UIStackView,
        mainText: String,
        subText: String,
        clickable: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        let rowStackView = UIStackView()
        let dividerView = DividerView()

        rowStackView.axis = .horizontal
        rowStackView.distribution = .equalSpacing
        rowStackView.alignment = .center
        rowStackView.isLayoutMarginsRelativeArrangement = true
        rowStackView.layoutMargins = Constant.descriptionStackViewInset

        let mainLabel = UILabel()
        let subLabel = UILabel()
        subLabel.attributedText = .makeStyledString(font: .b_s_r, text: subText)

        if clickable {
            let imageView = UIImageView(image: DesignSystemAsset.image(named: "rightArrow"))
            let clickableStack = UIStackView(arrangedSubviews: [mainLabel, imageView])
            clickableStack.axis = .horizontal
            clickableStack.spacing = 4
            clickableStack.alignment = .center

            mainLabel.attributedText = .makeStyledUnderlinedString(font: .sub_m_sb, text: mainText)
            mainLabel.isUserInteractionEnabled = true

            mainLabel.rx.tapGesture()
                .when(.recognized)
                .bind { _ in
                    onTap?()
                }
                .disposed(by: disposeBag)

            rowStackView.addArrangedSubview(clickableStack)
        } else {
            mainLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: mainText)
            rowStackView.addArrangedSubview(mainLabel)
        }

        rowStackView.addArrangedSubview(subLabel)

        if let lastDivider = stackView.arrangedSubviews.last as? DividerView {
            lastDivider.isHidden = false
        }

        stackView.addArrangedSubview(rowStackView)
        stackView.addArrangedSubview(dividerView)

        dividerView.isHidden = true

        rowStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.height)
        }

        dividerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.dividerHeight)
        }
    }
}
