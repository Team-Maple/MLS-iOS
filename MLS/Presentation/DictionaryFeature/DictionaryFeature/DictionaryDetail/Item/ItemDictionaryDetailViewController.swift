import UIKit // 퍼스트 파티
// 모듈
import DesignSystem
import DomainInterface
// 써드파티
import ReactorKit


class ItemDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    
    public typealias Reactor = ItemDictionaryDetailReactor
    // MARK: - Components
    var detailView = ItemDictionaryDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .item
        titleText = "아이템 상세정보"
        inject(input: DictionaryDetailBaseViewController.Input(image: DesignSystemAsset.image(named: "testImage2"), backgroundColor: type.backgroundColor, name: "뇌전수리검", subText: "Lv10"))
        addViews()
        // 상세 정보 속 아이템 정보 스택뷰 생성
        makeDetailDescriptionStackView()
        // 드롭 몬스터 스택 뷰 생성
        makeDropMonsterStackView()
        setupConstraints()
    }
}

extension ItemDictionaryDetailViewController {
    override func didSelectMenuTab(index: Int) {
        switch index {
        case 0:
            detailView.detailInfoStackView.isHidden = false
            detailView.detailDropMonsterStackView.isHidden = true
        case 1:
            detailView.detailInfoStackView.isHidden = true
            detailView.detailDropMonsterStackView.isHidden = false
        default:
            detailView.detailInfoStackView.isHidden = false
            detailView.detailDropMonsterStackView.isHidden = true
        }
    }
}

// MARK: - Setup
private extension ItemDictionaryDetailViewController {
    func addViews() {
        mainView.secondSectionStackView.addArrangedSubview(detailView.detailInfoStackView)
        mainView.secondSectionStackView.addArrangedSubview(detailView.detailDropMonsterStackView)
    }
    
    func setupConstraints() {
        detailView.detailInfoStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        detailView.detailDropMonsterStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}

private extension ItemDictionaryDetailViewController {
    func makeDetailDescriptionStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.itemInfos
        
        for info in infos {
            let stackView = detailView.detailDesctiptionItemStackViewSetup()
            let mainLabel = UILabel()
            mainLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: info.name)
            
            let subLabel = UILabel()
            subLabel.attributedText = .makeStyledString(font: .b_s_r, text: info.desc)
            
            stackView.addArrangedSubview(mainLabel)
            stackView.addArrangedSubview(subLabel)
        }
    }
    // 드롭몬스터 스택 뷰 생성
    func makeDropMonsterStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.monsterInfos
        
        for info in infos {
            // 일단 데이터 모델을 만들기는 했는데 뷰에 어떻게 전달하지 고민해보기
            detailView.dropMonsterViewSetup()
        }
    }
}

// MARK: - Bind
extension ItemDictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindUserAction(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    
    private func bindUserAction(reactor: Reactor) {
        
    }
    
    private func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.type.detailTypes)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] types in
                self?.setupMenu(types)
            })
            .disposed(by: disposeBag)
    }
}
