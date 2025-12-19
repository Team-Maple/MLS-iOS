import UIKit

import BaseFeature
import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

final class MapDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MapDictionaryDetailReactor

    // MARK: - Componenets
    private var mapInfoView = DetailStackMapView(imageUrl: "")
    private var appearMonsterView = DetailStackCardView()
    private var appearNpcView = DetailStackCardView()
    private let sortedFactory: SortedBottomSheetFactory = SortedBottomSheetFactoryImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindImageView()
    }

    override func toggleBookmark() {
        reactor?.action.onNext(.toggleBookmark)
    }

    override func checkLogin() -> Bool {
        guard let reactor = reactor else { return false }
        return reactor.currentState.isLogin
    }

    override func undoBookmark() {
        reactor?.action.onNext(.undoLastDeletedBookmark)
    }
}

// MARK: - SetUp
private extension MapDictionaryDetailViewController {
    func setUpMainInfo() {
        guard let reactor = reactor else { return }
        let info = reactor.currentState.mapDetailInfo
        inject(
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
            mapInfoView.setUpMapView(imageUrl: reactor.currentState.mapDetailInfo.mapUrl)
            contentViews[0] = mapInfoView
        } else {
            contentViews[0] = DetailEmptyView(type: .mapInfo)
        }
    }

    func setUpMonsterView() {
        guard let reactor = reactor,
              let filter = reactor.currentState.monsterFilter.first else { return }
        appearMonsterView.initFilter(firstFilter: filter)

        appearMonsterView.reset()
        let monsters = reactor.currentState.spawnMonsters
        contentViews.append(appearMonsterView)
        if monsters.isEmpty {
            contentViews[1] = DetailEmptyView(type: .appearMonsterWithText)
        } else {
            contentViews[1] = appearMonsterView
            for monster in monsters {
                appearMonsterView.inject(input: DetailStackCardView.Input(type: .appearMonsterWithText, imageUrl: monster.imageUrl ?? "", mainText: monster.monsterName, subText: "Lv.\(monster.level ?? 0)", additionalText: {
                    if let count = monster.maxSpawnCount {
                        return "\(count)마리"
                    } else {
                        return "??마리"
                    }
                }()))
            }
        }
    }

    func setUpNpcView() {
        guard let reactor = reactor else { return }

        let npcs = reactor.currentState.npcs
        appearNpcView.reset()
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
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                guard let reactor = owner.reactor,
                      let url = reactor.currentState.mapDetailInfo.mapUrl else { return }
                let viewController = PinchMapViewController(imageUrl: url)
                viewController.modalPresentationStyle = .overFullScreen
                owner.isBottomTabbarHidden = true
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
        bindReportButton(providerId: reactor.state.map { $0.mapDetailInfo.mapId }, itemName: reactor.state.map { $0.mapDetailInfo.nameKr ?? "" })
    }

    private func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        appearMonsterView.filterButton.rx.tap
            .map { Reactor.Action.monsterFilterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        appearMonsterView.tap
            .map { Reactor.Action.monsterTapped(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        appearNpcView.tap
            .map { Reactor.Action.npcTapped(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        reactor.state.map(\.mapDetailInfo)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, item in
                owner.setUpMainInfo()
                owner.setUpMapView()
                owner.mainView.setBookmark(isBookmarked: item.bookmarkId != nil)
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.spawnMonsters)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.setUpMonsterView()
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.npcs)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.setUpNpcView()
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) } // 값이 바뀔때만 이벤트 받음
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case .filter(let sort):
                    let viewController = owner.sortedFactory.make(sortedOptions: sort, selectedIndex: owner.selectedIndex) { index in
                        owner.selectedIndex = index
                        let selectedFilter = reactor.currentState.monsterFilter[index]
                        owner.appearMonsterView.selectFilter(selectedType: selectedFilter)
                        reactor.action.onNext(.selectFilter(selectedFilter))
                    }
                    owner.tabBarController?.presentModal(viewController, hideTabBar: true)
                case .detail(let type, let id):
                    let viewController = owner.dictionaryDetailFactory.make(type: type, id: id, bookmarkRelay: owner.bookmarkRelay, loginRelay: owner.loginRelay)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .bookmarkError:
                    ToastFactory.createToast(message: "북마크 요청에 실패했어요. 다시 시도해주세요.")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$event)
            .bind(onNext: { [weak self] event in
                switch event {
                case let .add(item):
                    self?.presentAddSnackBar(
                        bookmarkId: item.bookmarkId,
                        imageUrl: item.iconUrl,
                        background: DictionaryItemType.item.backgroundColor
                    )
                    self?.bookmarkRelay?.accept((item.mapId, item.bookmarkId))
                case let .delete(item):
                    self?.presentDeleteSnackBar(
                        imageUrl: item.iconUrl,
                        background: DictionaryItemType.item.backgroundColor
                    )
                    self?.bookmarkRelay?.accept((item.mapId, item.bookmarkId))
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
}
