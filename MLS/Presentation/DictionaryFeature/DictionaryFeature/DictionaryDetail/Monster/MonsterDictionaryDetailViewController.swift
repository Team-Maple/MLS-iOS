import UIKit
import DomainInterface
import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift


class MonsterDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MonsterDictionaryDetailReactor
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    // MARK: - Componenets
    var detailView = MonsterDictionaryDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: - 리액터로 옮겨야 할 것들 많음.
        type = .monster
        inject(input: DictionaryDetailBaseViewController.Input(image: DesignSystemAsset.image(named: "testImage"), backgroundColor: type.backgroundColor, name: "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트", subText: "Lv21"))
        addViews()
        setupConstraints()
        // 상세 설명 뷰 만들기
        makeDetailDescriptionTextView()
        // 출현 맵 뷰 만들기
        makeSpawnMapView()
        
    }
}

// MARK: - SetUp
private extension MonsterDictionaryDetailViewController {
    // 각 타입별 세그먼트 뷰 추가
    func addViews() {
        mainView.secondSectionStackView.addArrangedSubview(detailView.detailDescriptionStackView)
        mainView.secondSectionStackView.addArrangedSubview(detailView.detailMapStackView)
    }
    
    func setupConstraints() {
        detailView.detailDescriptionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(16)
        }
        
        detailView.detailMapStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(16)
        }
    }
}

private extension MonsterDictionaryDetailViewController {
    // 상세 설명에 맞는 텍스트 스택 뷰 생성 - (이름            설명)
    func makeDetailDescriptionTextView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.menus.infos
     
        for info in infos {
            let stackView = UIStackView()
            // 가로 스택 뷰
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing // 좌우 label 사이 간격 고르게
            stackView.alignment = .center
            // 내부 패딩값 주기
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
            
            let mainLabel = UILabel()
            mainLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: info.name)
            
            let subLabel = UILabel()
            subLabel.attributedText = .makeStyledString(font: .b_s_r, text: info.desc)
            
            stackView.addArrangedSubview(mainLabel)
            stackView.addArrangedSubview(subLabel)
            
            detailView.detailDescriptionStackView.addArrangedSubview(stackView)
            
            stackView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(10)
                make.height.equalTo(50)
            }
        }
    }
    
    // 출현 맵 뷰 생성(임시)
    func makeSpawnMapView() {
        let label = UILabel()
        label.text = "출현 맵 정보 표시"
        label.textAlignment = .center
        detailView.detailMapStackView.addArrangedSubview(label)
    }
}

extension MonsterDictionaryDetailViewController {
    // 베이스 뷰컨의 메뉴 탭 클릭시 발생할 이벤트 오버라이딩
    override func didSelectMenuTab(index: Int) {
        // TODO: 각 메뉴 탭에 맞는 뷰 보여주기
        
        // 각 메뉴 탭에 맞는 뷰 추가
        switch index {
        case 0: //상세설명
           //makeDetailDescriptionTextView()
            detailView.detailDescriptionStackView.isHidden = false
            detailView.detailMapStackView.isHidden = true
        default:
            // 출현 맵 - 임시 라벨로 대체
            detailView.detailMapStackView.isHidden = false
            detailView.detailDescriptionStackView.isHidden = true
        }
    }
}

// MARK: - Bind
extension MonsterDictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindcUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    
    func bindcUserActions(reactor: Reactor) {
        
    }
    
    func bindViewState(reactor: Reactor) {
        
        reactor.state
            .map(\.type)
            // UI 변경은 메인 스레드에서 하도록 (Rx에서 제공하는 문법인듯)
            // UI 업데이트 할 때는 쓰는게 안전하다고 함.
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.titleText = "몬스터 상세정보"
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.tags)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] tags in
                self?.makeTagsRow(tags)
            })
            .disposed(by: disposeBag)
        // 자식 타입의 메뉴탭 타입들
        reactor.state
            .map(\.type.detailTypes)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] types in
                /// detailTypes에 들어있는 모든 타입을 넘겨줌
                ///  [.normal, .appearMap, .dropItem]
                self?.setupMenu(types)
            })
            .disposed(by: disposeBag)
    }
}
