import UIKit

import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

final class MapDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MapDictionaryDetailReactor

    // MARK: - Componenets
    private var mapInfoView: DetailStackMapView
    private var appearMonsterView = DetailStackCardView()
    private var appearNpcView = DetailStackCardView()
    private let sortedFactory: SortedBottomSheetFactory = SortedBottomSheetFactoryImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindImageView()
    }

    init(imageUrl: String) {
        self.mapInfoView = DetailStackMapView(imageUrl: imageUrl)

        super.init(type: .map)
    }
}

// MARK: - SetUp
private extension MapDictionaryDetailViewController {
    func setUpMainInfo() {
        guard let reactor = reactor else { return }
        let info = reactor.currentState.mapDetailInfo
        self.inject(
            input: DictionaryDetailBaseViewController
                .Input(
                    imageUrl: info.iconUrl,
                    backgroundColor: type.backgroundColor,
                    name: info.nameKr ?? "이름 없음",
                    subText: info.detailName ?? ""
                )
        )
    }

    func setUpMapView() {
        guard let reactor = reactor else { return }

        contentViews.append(mapInfoView)
        if let mapUrl = reactor.currentState.mapDetailInfo.mapUrl, !mapUrl.isEmpty {
            contentViews[0] = mapInfoView
        } else {
            contentViews[0] = DetailEmptyView(type: .mapInfo)
        }
    }

    func setUpMonsterView() {
        guard let reactor = reactor,
              let filter = reactor.currentState.type.detailSortedFilter.first else { return }
        appearMonsterView.initFilter(firstFilter: filter)

        let monsters = reactor.currentState.spawnMonsters
        contentViews.append(appearMonsterView)
        if monsters.isEmpty {
            contentViews[1] = DetailEmptyView(type: .appearMonsterWithText)
        } else {
            contentViews[1] = appearMonsterView
            for monster in monsters {
                appearMonsterView.inject(input: DetailStackCardView.Input(type: .appearMonsterWithText, imageUrl: monster.imageUrl ?? "", mainText: monster.monsterName, subText: "Lv.\(monster.level ?? 0)"))
            }
        }
    }

    func setUpNpcView() {
        guard let reactor = reactor, let filter = reactor.currentState.type.detailSortedFilter.first else { return }
        appearNpcView.initFilter(firstFilter: filter)
        let npcs = reactor.currentState.npcs
        contentViews.append(appearNpcView)
        if npcs.isEmpty {
            contentViews[2] = DetailEmptyView(type: .appearNPC)
        } else {
            contentViews[2] = appearNpcView
            for npc in npcs {
                appearNpcView.inject(input: DetailStackCardView.Input(type: .appearNPC, imageUrl: npc.iconUrl ?? "", mainText: npc.npcName))
            }
        }
    }

    func bindImageView() {
        let tapGesture = UITapGestureRecognizer()
        mapInfoView.mapImageView.isUserInteractionEnabled = true
        mapInfoView.mapImageView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
               .bind(onNext: { [weak self] _ in
                   guard let self else { return }
                   let viewController = PinchMapViewController(imageUrl: "")
                   viewController.modalPresentationStyle = .overFullScreen
                   self.present(viewController, animated: true)
               })
               .disposed(by: disposeBag)
    }
}

// MARK: - Bind
extension MapDictionaryDetailViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {
        appearMonsterView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        reactor.state.map(\.mapDetailInfo)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.setUpMainInfo()
                self?.setUpMapView()
            })
            .disposed(by: disposeBag)
        reactor.state.map(\.spawnMonsters)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.setUpMonsterView()
            })
            .disposed(by: disposeBag)
        reactor.state.map(\.npcs)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.setUpNpcView()
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in return reactor.pulse(\.$route) } // 값이 바뀔때만 이벤트 받음
            .withUnretained(self)
            .subscribe { (owner, route) in
                switch route {
                case .filter(let type):
                    let viewController = owner.sortedFactory.make(sortedOptions: type.detailSortedFilter, selectedIndex: owner.selectedIndex) { index in
                        owner.selectedIndex = index
                        let selectedFilter = reactor.currentState.type.detailSortedFilter[index]
                        owner.appearMonsterView.selectFilter(selectedType: selectedFilter)
                    }
                    owner.tabBarController?.presentModal(viewController)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)

        rx.viewWillAppear.take(1).subscribe { _ in
            reactor.action.onNext(.viewWillAppear)
        }
        .disposed(by: disposeBag)
    }
}
