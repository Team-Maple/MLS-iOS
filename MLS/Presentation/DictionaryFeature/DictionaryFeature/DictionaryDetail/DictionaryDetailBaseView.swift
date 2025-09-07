import UIKit

import DesignSystem
import DomainInterface

import SnapKit

class DictionaryDetailBaseView: UIView {
    // MARK: - Type
    public enum Constant {
        static let iconInset: CGFloat = 10
        static let navHeight: CGFloat = 44
        static let buttonSize: CGFloat = 44
        static let imageRadius: CGFloat = 24
        static let imageContentViewSize: CGFloat = 160
        static let imageSize: CGFloat = 112
        static let imageBottomMargin: CGFloat = 12
        static let horizontalInset: CGFloat = 16
        static let bookmarkViewSize: CGFloat = 44
        static let bookmarkViewMargin: CGFloat = 6
        static let bookmarkViewInset: CGFloat = 10
        static let textMargin: CGFloat = 4
        static let stickyHeight: CGFloat = 56
        static let dividerHeight: CGFloat = 1
        static let tagsBottomMargin: CGFloat = 30
        static let tabBarHeight: CGFloat = 40
        static let tabBarTopMargin: CGFloat = 30
        static let imageContentTopMargin: CGFloat = 20
        static let tagVerticalSpacing: CGFloat = 10
        static let tabBarSpacing: CGFloat = 20
        static let badgeHeight: CGFloat = 24
        static let numberOfLines: Int = 0
        static let tabBarStackViewInset: UIEdgeInsets = UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16)
        static let tagStackViewInset: UIEdgeInsets =  UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        static let secondSectionStackViewInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        static let menuTabBarButtonInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 9, leading: 4, bottom: 9, trailing: 4)
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

    public var titleLabel: UILabel = {
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
        scrollView.backgroundColor = .neutral100
        return scrollView
    }()
    /// 스크롤 뷰에 들어갈 컴포넌트들을 담을 스택 뷰
    ///  각 컴포너트들의 간격이 다 다름
    public let stackView: UIStackView = {
        let stackView = UIStackView()
        // 수직 스택 뷰
        stackView.axis = .vertical
        stackView.backgroundColor = .whiteMLS
        // 아이템 기본 중앙배치
        stackView.alignment = .center

        return stackView
    }()
    public let imageContentView: UIView = {
        let view = UIView()
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
    public let bookmarkContentView: UIView = {
        let view = UIView()
        return view
    }()

    // 북마크 버튼
    public let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "bookmarkGrayBorder"), for: .normal)
        return button
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
        stackView.spacing = Constant.tagVerticalSpacing
        // horizontal tag들이 중앙정렬 되도록
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.tagStackViewInset

        return stackView
    }()

    // tabBar StackView
    public let tabBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .whiteMLS
        stackView.distribution = .fill
        stackView.spacing = Constant.tabBarSpacing
        stackView.alignment = .leading
        // layoutMargins을 사용하여 inset 설정
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.tabBarStackViewInset

        return stackView
    }()

    // tabBar Sticky StackView
    public let tabBarStickyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .whiteMLS
        stackView.distribution = .fill
        stackView.spacing = Constant.tabBarSpacing
        stackView.alignment = .bottom
        // layoutMargins을 사용하여 inset 설정
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.tabBarStackViewInset
        stackView.isHidden = true

        return stackView
    }()

    // tabBar 하단 구분선
    public let tabBarDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral300

        return view
    }()

    // sticky tab Bar 하단 구분선
    public let stickyTabBarDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral300
        view.isHidden = true
        return view
    }()

    // 두번째 섹션 스택 뷰 (배경색 바뀌는 부분)
    public let secondSectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .neutral100
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.secondSectionStackViewInset

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
        scrollView.addSubview(stickyTabBarDividerView)

        imageContentView.addSubview(imageView)
        imageContentView.addSubview(bookmarkContentView)
        bookmarkContentView.addSubview(bookmarkButton)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
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
            make.horizontalEdges.equalToSuperview()
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

        bookmarkContentView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Constant.bookmarkViewMargin)
            make.size.equalTo(Constant.bookmarkViewSize)
        }

        bookmarkButton.snp.makeConstraints { make in
            make.center.equalToSuperview().inset(Constant.bookmarkViewInset)
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
            // make.height.equalTo(Constant.tabBarHeight)
            make.width.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom)
        }

        tabBarDividerView.snp.makeConstraints { make in
            make.height.equalTo(Constant.dividerHeight)
            make.top.equalTo(tabBarStackView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }

        // centerX와 horizontal을 각각 잡은이유
        secondSectionStackView.snp.makeConstraints { make in
            make.top.equalTo(tabBarStackView.snp.bottom)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(scrollView.snp.bottom)
        }

        tabBarStickyStackView.snp.makeConstraints { make in
            // make.height.equalTo(Constant.stickyHeight)
            make.width.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }

        stickyTabBarDividerView.snp.makeConstraints { make in
            make.top.equalTo(tabBarStickyStackView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constant.dividerHeight)

        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
    }
}

extension DictionaryDetailBaseView {
    func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = DictionaryDetailBaseView.Constant.tagVerticalSpacing
        stackView.distribution = .fill
        return stackView
    }
    // 메뉴 탭바 버튼 생성하기
    func createMenuButton(title: String, tag: Int) -> UIButton {
        var config = setupConfig()

        let button = UIButton(configuration: config)
        button.setAttributedTitle(.makeStyledString(font: .b_m_r, text: title), for: .normal)
        button.setTitleColor(.neutral600, for: .normal)
        button.titleLabel?.font = UIFont.b_m_r
        button.tag = tag
        return button
    }

    func setupConfig() -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = Constant.menuTabBarButtonInset
        return config
    }

    // 태그 뱃지 제약사항 설정
    func setBadgeConstraints(_ badge: Badge, width: CGFloat) {
        badge.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(DictionaryDetailBaseView.Constant.badgeHeight)
        }
    }
    
    func setTabView(index: Int, contentViews: [UIView]) {
        // 기존 뷰 제거
        for view in secondSectionStackView.arrangedSubviews {
            secondSectionStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        // 새 뷰 추가
        let newView = contentViews[index]
        secondSectionStackView.addArrangedSubview(newView)
        
        // constraint 유지
        newView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    func setupSpacerView() {
        let spacerView = UIView()
        let stickySpacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stickySpacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        tabBarStackView.addArrangedSubview(spacerView)
        tabBarStickyStackView.addArrangedSubview(stickySpacerView)
    }
}
