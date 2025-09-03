import UIKit

import DesignSystem

import SnapKit

final class DetailStackInfoView: UIStackView {
    // MARK: - Type
    enum Constant {
        static let descriptionCornerRadius: CGFloat = 16
        static let descriptionStackViewInset: UIEdgeInsets = .init(top: 14, left: 16, bottom: 14, right: 16)
        static let detailInfoStackViewInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        static let height: CGFloat = 50
        static let dividerHeight: CGFloat = 1
        static let horizontalInset: CGFloat = 10
        static let detailInfoStackViewSpacing: CGFloat = 20
    }
    
    // MARK: - Components
    // 상세정보 스택 뷰 속 설명 글
    private let descriptionLabel: UILabel = {
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
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        configureUI()
        addViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DetailStackInfoView {
    func addViews() {
        addArrangedSubview(descriptionLabel)
        addArrangedSubview(infoStackView)
    }
    
    func configureUI() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = Constant.detailInfoStackViewSpacing
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = Constant.detailInfoStackViewInset
    }
}

// MARK: - Methods
extension DetailStackInfoView {
    /// 아이템 상세정보 한 줄 추가
    func addInfo(mainText: String, subText: String) {
        let stackView = UIStackView()
        let dividerView = DividerView()

        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing // 좌우 label 사이 간격 고르게
        stackView.alignment = .center
        // 내부 패딩값 주기
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.descriptionStackViewInset
        
        let mainLabel = UILabel()
        mainLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: mainText)

        let subLabel = UILabel()
        subLabel.attributedText = .makeStyledString(font: .b_s_r, text: subText)

        stackView.addArrangedSubview(mainLabel)
        stackView.addArrangedSubview(subLabel)

        infoStackView.addArrangedSubview(stackView)
        infoStackView.addArrangedSubview(dividerView)

        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.height)
        }

        dividerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.dividerHeight)
        }
    }
}
