import UIKit

import BaseFeature
import DesignSystem
import DomainInterface

import RxCocoa
import RxSwift

class DictionaryDetailBaseViewController: BaseViewController {
    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private var didSelectInitialTab = false

    /// 각 탭에 해당하는 콘텐츠 뷰들을 담는 배열
    public var contentViews: [UIView] = []

    /// 현재 보여지고 있는 뷰의 인덱스
    private var currentTabIndex: Int?

    // MARK: - Components
    private var mainView = DictionaryDetailBaseView()

    // 타입설정
    public var type: DictionaryItemType

    public init(type: DictionaryItemType) {
        self.type = type
        mainView.titleLabel.attributedText = .makeStyledString(font: .sub_m_b, text: type.detailTitle)
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        bindActions() // 액션 바인딩
        mainView.scrollView.delegate = self
        setupMenu(type.detailTypes)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 처음 진입 및 뷰가 추가 되었는지 확인
        if !didSelectInitialTab {
            didSelectMenuTab(index: 0)
            didSelectInitialTab = true
        }
    }
}

// MARK: - SetUp
private extension DictionaryDetailBaseViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

/// 스티키 헤더 만들기 위한 델리게이트
extension DictionaryDetailBaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 탭바의 frame을 self.view 기준으로 변환
        let tabBarY = mainView.tabBarStackView.convert(mainView.tabBarStackView.bounds, to: view)

        if tabBarY.origin.y <= view.safeAreaInsets.top + DictionaryDetailBaseView.Constant.buttonSize + DictionaryDetailBaseView.Constant.horizontalInset - DictionaryDetailBaseView.Constant.tabBarStackViewInset.top { // safearea + 헤더뷰 + 헤더뷰와의 간격 16 = 122
            mainView.tabBarStickyStackView.isHidden = false
            mainView.stickyTabBarDividerView.isHidden = false
        } else {
            mainView.tabBarStickyStackView.isHidden = true
            mainView.stickyTabBarDividerView.isHidden = true
        }

        let nameY = mainView.nameLabel.convert(mainView.nameLabel.bounds, to: view)

        if nameY.origin.y <= view.safeAreaInsets.top + DictionaryDetailBaseView.Constant.buttonSize + DictionaryDetailBaseView.Constant.horizontalInset {
            // 메랜에서 이름이 가장 긴 몬스터의 경우 '다크 주니어 예티와 페페'로 알고 있는데, 따로 텍스트 길이에 대한 제약사항을 안줘도 다크 주니어 예티와 페페가 잘 표시가 됨. 제약사항 필요한가?
            mainView.titleLabel.attributedText = .makeStyledString(font: .sub_m_b, text: mainView.nameLabel.text)
        } else {
            mainView.titleLabel.attributedText = .makeStyledString(font: .sub_m_b, text: type.detailTitle)
        }
    }
}

extension DictionaryDetailBaseViewController {
    /// image: 메인 이미지
    /// backgroundColor: dictionaryItemType에 따른 배경 색
    /// name: 해당 dict의 이름
    /// subText: level, 지역 등 다양한 서브 텍스트
    struct Input {
        let image: UIImage?
        let backgroundColor: UIColor
        let name: String
        let subText: String? // 없는 경우도 있는듯
    }

    func inject(input: Input) {
        mainView.imageView.image = input.image
        mainView.imageContentView.backgroundColor = input.backgroundColor
        mainView.nameLabel.attributedText = .makeStyledString(font: .sub_l_m, text: input.name, color: .textColor)
        mainView.subTextLabel.attributedText = .makeStyledString(font: .b_s_r, text: input.subText, color: .neutral500)
    }

    func makeTagsRow(_ tags: [String]) {
        let maxWidth = UIScreen.main.bounds.width - DictionaryDetailBaseView.Constant.horizontalInset // 좌우 여백 고려 (16 * 2)
        let tagSpacing: CGFloat = DictionaryDetailBaseView.Constant.tagVerticalSpacing

        var tagsRowStackView = mainView.createHorizontalStackView()
        mainView.tagsVerticalStackView.addArrangedSubview(tagsRowStackView)

        var currentRowWidth: CGFloat = 0

        for tag in tags {
            let badge = Badge(style: .element(tag))
            // 임시로 사이즈 계산용
            let fittingSize = badge.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let badgeWidth = fittingSize.width

            if currentRowWidth + badgeWidth + tagSpacing > maxWidth {
                tagsRowStackView = mainView.createHorizontalStackView()
                mainView.tagsVerticalStackView.addArrangedSubview(tagsRowStackView)
                currentRowWidth = 0
            }

            tagsRowStackView.addArrangedSubview(badge)
            currentRowWidth += badgeWidth + tagSpacing
            mainView.setBadgeConstraints(badge, width: badgeWidth)
        }
    }

    // 탭바 메뉴 버튼 구성하기(스티키 쪽도 똑같이 구현)
    func setupMenu(_ menus: [DetailType]) {
        var firstIndexButton: UIButton? // 처음 화면 나올때 첫번째 버튼 클릭되게 하기 위해 첫번째 버튼 저장할 변수
        var firstStickyIndexButton: UIButton?
        // 버튼 configuration 설정 -> inset 설정
        for (index, menu) in menus.enumerated() {
            let button = mainView.createMenuButton(title: menu.description, tag: index)
            button.rx.tap.bind { [weak self] _ in
                self?.menuTabTapped(button)
            }
            .disposed(by: disposeBag)

            let stickyButton = mainView.createMenuButton(title: menu.description, tag: index)
            stickyButton.rx.tap.bind { [weak self] _ in
                self?.menuTabTapped(stickyButton)
            }
            .disposed(by: disposeBag)

            mainView.tabBarStackView.addArrangedSubview(button)
            mainView.tabBarStickyStackView.addArrangedSubview(stickyButton) // 스티키 역할을 할 스택뷰에다가도 똑같은 버튼 추가

            if index == 0 {
                firstIndexButton = button
                firstStickyIndexButton = button
            }
        }
        mainView.setupSpacerView()
        // 화면에 버튼 다 생성 한 이후에 첫번째 버튼 클릭 이벤트 유발
        if let firstIndexButton = firstIndexButton, let firstStickyIndexButton = firstStickyIndexButton {
            menuTabTapped(firstIndexButton)
            menuTabTapped(firstStickyIndexButton)
        }
    }

    private func menuTabTapped(_ sender: UIButton) {
        let selectedTag = sender.tag

        updateButtonStates(in: mainView.tabBarStackView, selectedTag: selectedTag)
        // 스티키 탭 버튼 상태 변경
        updateButtonStates(in: mainView.tabBarStickyStackView, selectedTag: selectedTag)

        // 자식 디테일 뷰컨에서 오버라이드 해서 사용하기?
        didSelectMenuTab(index: sender.tag)
    }

    // 버튼 상태 변경 함수
    private func updateButtonStates(in stackView: UIStackView, selectedTag: Int) {
        for (i, subview) in stackView.arrangedSubviews.enumerated() {
            guard let button = subview as? UIButton else { continue }
            let title = button.titleLabel?.text ?? ""

            let underline = button.subviews.first { $0.tag == DictionaryDetailBaseView.Constant.underTag }

            if i == selectedTag {
                button.setAttributedTitle(.makeStyledString(font: .sub_m_b, text: title, color: .black), for: .normal)
                underline?.isHidden = false
            } else {
                button.setAttributedTitle(.makeStyledString(font: .b_m_r, text: title, color: .neutral600), for: .normal)
                underline?.isHidden = true
            }
        }
    }

    // 북마크 버튼 클릭 시
    func updateBookmarkButton(isBookmarked: Bool) {
        // TODO: 북마크 버튼 누르면 이벤트 발생
    }

    func didSelectMenuTab(index: Int) {
        // 인덱스 유효성 검사
        guard index < contentViews.count else { return }

        // 현재 뷰가 같다면 변경 안함
        if currentTabIndex == index { return }
        // 각 탭에 맞는 뷰 설정
        mainView.setTabView(index: index, contentViews: contentViews)

        currentTabIndex = index
    }
}

private extension DictionaryDetailBaseViewController {
    func bindActions() {
        // 뒤로가기 버튼 액션 바인드
        bindBackButton()
        bindBookmarkButton()
    }

    func bindBackButton() {
        mainView.backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    // 이부분은 왜 inject로 넣어야 하나??
    func bindBookmarkButton() {
        mainView.bookmarkButton.rx.tap
            .bind { [weak self] in
                print("bookmark tapped")
            }
            .disposed(by: disposeBag)
    }
}
