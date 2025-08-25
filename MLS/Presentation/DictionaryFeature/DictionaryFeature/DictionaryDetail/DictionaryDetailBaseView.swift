import UIKit

import DesignSystem
import DomainInterface

import SnapKit

final class DictionaryDetailBaseView: UIView {
    // MARK: - Type
    enum Constant {
        static let iconInset: CGFloat = 10
        static let navHeight: CGFloat = 44
        static let buttonSize: CGFloat = 44
        static let imageRadius: CGFloat = 24
        static let imageContentViewSize: CGFloat = 160
        static let imageSize: CGFloat = 112
        static let imageBottomMargin: CGFloat = 12
        static let horizontalInset: CGFloat = 16
        static let textMargin: CGFloat = 4
        static let stickyHeight: CGFloat = 56
        static let dividerHeight: CGFloat = 1
        static let tagsBottomMargin: CGFloat = 30
        static let tabBarHeight: CGFloat = 40
        static let tabBarTopMargin: CGFloat = 30
        static let imageContentTopMargin: CGFloat = 20
    }
    
    // MARK: - Components
    /// header에 들어가 컴포넌트들 담을 컨테이너 뷰
    public let headerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    public let backButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "arrowBack")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets.init(top: Constant.iconInset, left: Constant.iconInset, bottom: Constant.iconInset, right: Constant.iconInset)), for: .normal)
        button.tintColor = .textColor
        
        return button
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_b, text: "몬스터 상세 정보")
        
        return label
    }()
    
    public let dictButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "dictionary")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets.init(top: Constant.iconInset, left: Constant.iconInset, bottom: Constant.iconInset, right: Constant.iconInset)), for: .normal)
        button.tintColor = .textColor
        
        return button
    }()
    
    public let reportButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "errorBlack")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets.init(top: Constant.iconInset, left: Constant.iconInset, bottom: Constant.iconInset, right: Constant.iconInset)), for: .normal)
        button.tintColor = .textColor
        
        return button
    }()
    
    public let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    /// 스크롤 뷰에 들어갈 컴포넌트들을 담을 스택 뷰
    ///  각 컴포너트들의 간격이 다 다름
    public let stackView: UIStackView = {
        let stackView = UIStackView()
        // 수직 스택 뷰
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        // 아이템 기본 중앙배치
        stackView.alignment = .center
        
        return stackView
    }()
    public let imageContentView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constant.imageRadius
        
        return view
    }()
    // 이미지 뷰
    public let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    // 이름
    public let nameLabel: UILabel = {
        let label = UILabel()
        // 줄 수 제한 없음
        label.numberOfLines = 0
        // 단어 단위로 줄 바꿈
        label.lineBreakMode = .byWordWrapping
        // 가운데 정렬
        label.textAlignment = .center
        return label
    }()
    // SubText - level, 지역 등
    public let subTextLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    // tagView들을 담는 가로 stackView들을 담을 세로 stackView -> 말이 너무 어려운데..
    // 충분히 이해 하시겠죠...?ㅠㅠ
    public let tagsVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        // 각 가로 태그줄의 간격 10
        stackView.spacing = 10
        // horizontal tag들이 중앙정렬 되도록
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        return stackView
    }()
    
    // tabBar StackView
    public let tabBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .white
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.alignment = .leading
        // layoutMargins을 사용하여 inset 설정
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return stackView
    }()
    
    // tabBar Sticky StackView
    public let tabBarStickyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .white
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.alignment = .bottom
        // layoutMargins을 사용하여 inset 설정
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isHidden = true
        
        return stackView
    }()
    
    // tabBar 하단 구분선
    public let tabBarDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral100
        view.isHidden = true
        
        return view
    }()
    
    // 두번째 섹션 스택 뷰 (배경색 바뀌는 부분)
    public let secondSectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .neutral100
       
        return stackView
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictionaryDetailBaseView {
    func addViews() {
        // forEach 활용하여 중복코드 제거
        [backButton, titleLabel, dictButton, reportButton].forEach { headerView.addSubview($0) }

        [headerView, scrollView].forEach {
            addSubview($0)
        }
        // stackView를 scrollView안에 넣어줘야 함
        scrollView.addSubview(stackView)
        
        [imageContentView, nameLabel, subTextLabel, tagsVerticalStackView].forEach {
            // 스택뷰에 subView 추가
            stackView.addArrangedSubview($0)
        }
        scrollView.addSubview(secondSectionStackView)
        scrollView.addSubview(tabBarStackView)
        scrollView.addSubview(tabBarDividerView)
        scrollView.addSubview(tabBarStickyStackView)
       
        imageContentView.addSubview(imageView)
    }
    
    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constant.buttonSize)
        }
        backButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(Constant.buttonSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        dictButton.snp.makeConstraints { make in
            make.trailing.equalTo(reportButton.snp.leading)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constant.buttonSize)
        }

        reportButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(Constant.buttonSize)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        imageContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constant.imageContentTopMargin)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageContentViewSize)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constant.imageSize)
        }
        // 스택뷰 속 간격 커스텀 -> imageContentView와 다음 스택뷰 셀의 간격 imageBottomMargin 만큼
        stackView.setCustomSpacing(Constant.imageBottomMargin, after: imageContentView)
        
        nameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        
        // nameLabel과 그 아래에 들어올 subText간 간격 조정
        stackView.setCustomSpacing(Constant.textMargin, after: nameLabel)
        
        subTextLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        
        stackView.setCustomSpacing(Constant.textMargin, after: subTextLabel)
        
        tabBarStackView.snp.makeConstraints { make in
            make.height.equalTo(Constant.tabBarHeight)
            make.width.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(Constant.tagsBottomMargin)
        }
        
        tabBarDividerView.snp.makeConstraints { make in
            make.height.equalTo(Constant.dividerHeight)
            make.top.equalTo(tabBarStickyStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        secondSectionStackView.snp.makeConstraints { make in
            make.top.equalTo(tabBarStackView.snp.bottom)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(scrollView.snp.bottom)
        }

        tabBarStickyStackView.snp.makeConstraints { make in
            make.height.equalTo(Constant.stickyHeight)
            make.width.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    func configureUI() {
        backgroundColor = .whiteMLS
    }
}

