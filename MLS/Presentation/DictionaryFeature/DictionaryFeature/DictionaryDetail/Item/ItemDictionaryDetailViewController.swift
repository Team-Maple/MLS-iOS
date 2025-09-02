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
        // 최대한 파라미터로 데이터 전달을 하려했습니다.
        // 리액터 상태를 직접 전달은 안될 것 같아서
        for info in infos {
            let stackView = detailView.detailDesctiptionItemStackViewSetup()
            detailView.makeItemDetailDescriptionTextStackView(stackView: stackView, mainText: info.name, subText: info.desc)
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
