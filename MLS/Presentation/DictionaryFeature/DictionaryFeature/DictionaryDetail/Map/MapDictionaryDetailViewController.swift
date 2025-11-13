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

        mapInfoView.setUpMapView(imageUrl: reactor.currentState.mapDetailInfo.mapUrl)
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
        bindReportButton(providerId: reactor.state.map { $0.mapDetailInfo.mapId ?? 0 }, itemName: reactor.state.map { $0.mapDetailInfo.nameKr ?? "" })
    }

    private func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        appearMonsterView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped }
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

        bindBookmarkButton(
            buttonTap: mainView.bookmarkButton.rx.tap,
            currentItem: reactor.state.map { $0.mapDetailInfo },
            isLogin: { reactor.currentState.isLogin },
            imageUrl: { $0.mapUrl },
            backgroundColor: type.backgroundColor,
            isBookmarked: { $0.bookmarkId != nil },
            toggleBookmark: { isDeleting in reactor.action.onNext(.toggleBookmark(isDeleting)) },
            undoLastDeleted: { reactor.action.onNext(.undoLastDeletedBookmark) }
        )
        .disposed(by: disposeBag)
    }
}
