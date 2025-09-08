import DesignSystem
import DomainInterface
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class MonsterDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MonsterDictionaryDetailReactor

    // MARK: - Componenets
    private var detailView = DetailStackInfoView(type: .monster)
    private var appearMapView = DetailStackMapView(imageUrl: "")
    private var dropItemView = DetailStackCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .monster
        contentViews = [detailView, appearMapView, dropItemView]
        setupMainInfo()
        setUpInfoStackView()
        setupCardStackView()
    }
}

// MARK: - Populate Data
private extension MonsterDictionaryDetailViewController {
    func setupMainInfo() {
        // 상세정보
        self.inject(input: DictionaryDetailBaseViewController.Input(image: DesignSystemAsset.image(named: "testImage"), backgroundColor: type.backgroundColor, name: "다크 주니어 예티와 페페", subText: "Lv21"))
    }
    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.menus.infos

        for info in infos {
            detailView.addInfo(mainText: info.name, subText: info.desc)
        }
    }

    func setupCardStackView() {
        // 드롭아이템
        dropItemView.inject(input: DetailStackCardView.Input(type: .dropMonsterWithText, imageUrl: "imageUrl", mainText: "뇌전수리검", subText: "Lv.21", additionalText: "0.001%"))
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
            .map(\.tags)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] tags in
                self?.makeTagsRow(tags)
            })
            .disposed(by: disposeBag)
    }
}
