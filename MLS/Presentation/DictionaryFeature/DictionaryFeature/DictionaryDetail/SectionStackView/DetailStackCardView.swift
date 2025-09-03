import UIKit

import DesignSystem

import SnapKit

final class DetailStackCardView: UIStackView {
    // MARK: - Type
    private enum Constant {
        static let spacing: CGFloat = 12
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
    }

    func configureUI() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = Constant.spacing
    }
}

// MARK: - Methods
extension DetailStackCardView {
    // 드롭 몬스터 뷰 생성
    func addMonsterCard(name: String, level: String, dropRate: String, image: UIImage, backgroundColor: UIColor) {
        let cardView = CardList()
        cardView.setType(type: .detailStackText)
        cardView.setImage(image: image, backgroundColor: backgroundColor)
        cardView.mainText = name
        cardView.subText = level
        cardView.setDropInfoText(title: "드롭률", value: dropRate)

        addArrangedSubview(cardView)

        cardView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.cardHorizontalInset)
        }
    }
}
