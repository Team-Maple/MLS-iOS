import DesignSystem
import DomainInterface
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class MonsterDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MonsterDictionaryDetailReactor

    // MARK: - Componenets
    private var detailView = DetailStackInfoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: - 리액터로 옮겨야 할 것들 많음.
        type = .monster
        inject(input: DictionaryDetailBaseViewController.Input(image: DesignSystemAsset.image(named: "testImage"), backgroundColor: type.backgroundColor, name: "다크 주니어 예티와 페페", subText: "Lv21"))
        addViews()
        setUpInfoStackView()
    }
}

// MARK: - SetUp
private extension MonsterDictionaryDetailViewController {
    // 각 타입별 세그먼트 뷰 추가
    func addViews() {
        mainView.secondSectionStackView.addArrangedSubview(detailView)
    }
}

// MARK: - Populate Data
private extension MonsterDictionaryDetailViewController {
    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.menus.infos

        for info in infos {
            detailView.addInfo(mainText: info.name, subText: info.desc)
        }
    }
}

// MARK: - Bind
extension MonsterDictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindcUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindcUserActions(reactor: Reactor) {

    }

    private func bindViewState(reactor: Reactor) {

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
