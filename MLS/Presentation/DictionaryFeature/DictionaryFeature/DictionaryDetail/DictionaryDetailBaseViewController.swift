import UIKit

import BaseFeature
import BookmarkFeatureInterface
import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

class DictionaryDetailBaseViewController: BaseViewController {
    
    // MARK: - Components
    var mainView = DictionaryDetailBaseView()
    
    // 타입설정
    public var type: DictionaryItemType = .monster
    
    /// 자식이 여기서 설정할 수 있는 title
    public var titleText: String {
        get { mainView.titleLabel.text ?? "" }
        set {
            mainView.titleLabel.attributedText = .makeStyledString(font: .sub_m_b, text: newValue)
        }
    }
    
    public override init() {
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
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        mainView.scrollView.delegate = self
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
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
        let tabBarY = mainView.tabBarStackView.convert(mainView.tabBarStackView.bounds, to: self.view)

        if tabBarY.origin.y <= view.safeAreaInsets.top + 44 + 16 { // safearea + 헤더뷰 + 헤더뷰와의 간격 16 = 122
            mainView.tabBarStickyStackView.isHidden = false
            mainView.tabBarDividerView.isHidden = false
        } else {
            mainView.tabBarStickyStackView.isHidden = true
            mainView.tabBarDividerView.isHidden = true
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
    
    // tags 행들을 만드는 함수
    func makeTagsRow(_ tags: [String]) {
        // 추후 API 호출 데이터로 변경해줘야 함.
        // 일단 줄바꿈이 잘 되는지 테스트하기 위한 용도
        let tags: [String] = tags
        
        let maxWidth = UIScreen.main.bounds.width - 16 // 좌우 여백 고려
        // tag들 간 가로 간격
        let tagSpacing: CGFloat = 10
        
        var tagsRowStackView = UIStackView()
        
        tagsRowStackView.axis = .horizontal
        tagsRowStackView.alignment = .center
        tagsRowStackView.spacing = 10
        tagsRowStackView.distribution = .fill
        tagsRowStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        mainView.tagsVerticalStackView.addArrangedSubview(tagsRowStackView)
        
        var currentRowWidth: CGFloat = 0
        
        for tag in tags {
            
            let tagLabel = UILabel()
            tagLabel.attributedText = .makeStyledString(font: .cp_s_sb, text: tag, color: .primary500)
            tagLabel.backgroundColor = .primary25
            
            let tagWidth = tagLabel.intrinsicContentSize.width
            
            if currentRowWidth + tagWidth + tagSpacing > maxWidth {
                // 새 행 생성
                tagsRowStackView = UIStackView()
                tagsRowStackView.axis = .horizontal
                tagsRowStackView.alignment = .center
                tagsRowStackView.spacing = 10
                tagsRowStackView.distribution = .fill
                mainView.tagsVerticalStackView.addArrangedSubview(tagsRowStackView)
                currentRowWidth = 0
            }
            
            tagsRowStackView.addArrangedSubview(tagLabel)
            currentRowWidth += tagWidth + tagSpacing
        }
    }
   
    // 탭바 메뉴 버튼 구성하기(스티키 쪽도 똑같이 구현)
    func setupMenu(_ menus: [DetailType]) {
        var firstIndexButton: UIButton? // 처음 화면 나올때 첫번째 버튼 클릭되게 하기 위해 첫번째 버튼 저장할 변수
        var firstStickyIndexButton: UIButton?
        // 버튼 configuration 설정 -> inset 설정
        for (index, menu) in menus.enumerated() {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 4, bottom: 9, trailing: 4)

            let button = createMenuButton(title: menu.description, tag: index)
            
            let stickyButton = createMenuButton(title: menu.description, tag: index)
            
            mainView.tabBarStackView.addArrangedSubview(button)
            mainView.tabBarStickyStackView.addArrangedSubview(stickyButton) // 스티키 역할을 할 스택뷰에다가도 똑같은 버튼 추가
            
            if index == 0 {
                firstIndexButton = button
                firstStickyIndexButton = button
            }
            
            let spacerView = UIView() // 왼쪽 정렬을 위한 Spacer 추가
            
            let stickySpacerView = UIView()
            spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            stickySpacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            mainView.tabBarStackView.addArrangedSubview(spacerView)
            mainView.tabBarStickyStackView.addArrangedSubview(stickySpacerView)
            
           
        }
        // 화면에 버튼 다 생성 한 이후에 첫번째 버튼 클릭 이벤트 유발
        if let firstIndexButton = firstIndexButton, let firstStickyIndexButton = firstStickyIndexButton {
            menuTabTapped(firstIndexButton)
            menuTabTapped(firstStickyIndexButton)
        }
    }
    // 메뉴 탭바 버튼 생성하기
    private func createMenuButton(title: String, tag: Int) -> UIButton {
        var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 4, bottom: 9, trailing: 4)

            let button = UIButton(configuration: config)
            button.setAttributedTitle(.makeStyledString(font: .b_m_r, text: title), for: .normal)
            button.setTitleColor(.neutral600, for: .normal)
            button.titleLabel?.font = UIFont.b_m_r
            button.tag = tag
            button.addTarget(self, action: #selector(menuTabTapped(_:)), for: .touchUpInside)
            return button
    }
    
    @objc private func menuTabTapped(_ sender: UIButton) {
        let selectedTag = sender.tag

        updateButtonStates(in: mainView.tabBarStackView, selectedTag: selectedTag)
        // 스티키 탭 버튼 상태 변경
        updateButtonStates(in: mainView.tabBarStickyStackView, selectedTag: selectedTag)
        
        // 자식 디테일 뷰컨에서 오버라이드 해서 사용하기?
        didSelectMenuTab(index: sender.tag)
    }
    // 버튼 상태 변경 함수
    private func updateButtonStates(in stackView: UIStackView, selectedTag: Int) {
        for case let button as UIButton in stackView.arrangedSubviews {
            guard let title = button.titleLabel?.text else { continue }
            
            if button.tag == selectedTag {
                button.setAttributedTitle(.makeStyledString(font: .sub_m_b, text: title, color: .black), for: .normal)
            } else {
                button.setAttributedTitle(.makeStyledString(font: .sub_m_b, text: title, color: .neutral600), for: .normal)
            }
        }
    }
    // 자식 디테일 뷰에서 오버라이딩 하기
    @objc func didSelectMenuTab(index: Int) {
        
    }
}

