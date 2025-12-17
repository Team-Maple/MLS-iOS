import UIKit

import BaseFeature
import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

class MonsterDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MonsterDictionaryDetailReactor

    // MARK: - Properties
    private var dropItemSelectedIndex = 0
    private var mapSelectedIntdex = 0

    // MARK: - Componenets
    private var detailView = DetailStackInfoView(type: .monster)
    private var appearMapView = DetailStackCardView()
    private var dropItemView = DetailStackCardView()
    private let sortedFactory: SortedBottomSheetFactory = SortedBottomSheetFactoryImpl()

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

// MARK: - Populate Data
private extension MonsterDictionaryDetailViewController {
    func setUpMainInfo(name: String, subText: String, imageUrl: String?) {
        // 상세정보
        inject(
            input: DictionaryDetailBaseViewController
                .Input(
                    imageUrl: imageUrl,
                    backgroundColor: type.backgroundColor,
                    name: name,
                    subText: subText
                )
        )
    }

    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.infos

        contentViews.append(detailView)

        for info in infos {
            detailView.addInfo(mainText: info.name, subText: info.desc)
        }
    }

    func setUpMapView() {
        guard let reactor = reactor,
              let filter = reactor.currentState.mapFilter.first else { return }

        appearMapView.initFilter(firstFilter: filter)

        let maps = reactor.currentState.spawnMaps
        appearMapView.reset()
        contentViews.append(appearMapView)
        if maps.isEmpty {
            contentViews[1] = DetailEmptyView(type: .appearMap)
        } else {
            contentViews[1] = appearMapView

            for map in maps {
                appearMapView.inject(input: DetailStackCardView
                    .Input(
                        type: .appearMapWithText,
                        imageUrl: map.iconUrl,
                        mainText: map.mapName,
                        subText: map.regionName,
                        additionalText: {
                            if let count = map.maxSpawnCount {
                                return "\(count)마리"
                            } else {
                                return "??마리"
                            }
                        }()
                    )
                )
            }
        }
    }

    func setUpDropItemView() {
        guard let reactor = reactor,
              let filter = reactor.currentState.itemFilter.first else { return }

        dropItemView.initFilter(firstFilter: filter)
        let items = reactor.currentState.dropItems

        dropItemView.reset()
        contentViews.append(dropItemView)
        // 드롭아이템
        if items.isEmpty {
            // 드롭 아이템
            contentViews[2] = DetailEmptyView(type: .dropItemWithText)
        } else {
            contentViews[2] = dropItemView
            for item in items {
                dropItemView
                    .inject(
                        input: DetailStackCardView
                            .Input(
                                type: .dropItemWithText,
                                imageUrl: item.imageUrl,
                                mainText: item.itemName,
                                subText: "Lv.\(item.itemLevel)",
                                additionalText: "\(item.dropRate)%"
                            )
                    )
            }
        }
    }
}

// MARK: - Bind
extension MonsterDictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindcUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
        bindReportButton(providerId: reactor.state.map { $0.id }, itemName: reactor.state.map { $0.monsterDetailInfo.nameKr })
    }

    private func bindcUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        dropItemView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped(.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        appearMapView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped(.map) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        dropItemView.tap
            .map { Reactor.Action.itemTapped(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        appearMapView.tap
            .map { Reactor.Action.mapTapped(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        reactor.state.map(\.monsterDetailInfo)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, monster in
                if let tags = monster.typeEffectiveness {
                    owner.makeTagsRow(tags)
                }
                owner.setUpMainInfo(name: reactor.currentState.monsterDetailInfo.nameKr, subText: "Lv. \(reactor.currentState.monsterDetailInfo.level)", imageUrl: reactor.currentState.monsterDetailInfo.imageUrl)
                owner.mainView.setBookmark(isBookmarked: monster.bookmarkId != nil)
                owner.setUpInfoStackView()
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.spawnMaps)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.setUpMapView()
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.dropItems)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.setUpDropItemView()
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) } // 값이 바뀔때만 이벤트 받음
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case .filter(let type, let sort):
                    let selectedIndex = (type == .item) ? owner.dropItemSelectedIndex : owner.mapSelectedIntdex

                    let viewController = owner.sortedFactory.make(sortedOptions: sort, selectedIndex: selectedIndex) { index in
                        if type == .item {
                            owner.dropItemSelectedIndex = index
                            let selectedFilter = sort[index]
                            owner.dropItemView.selectFilter(selectedType: selectedFilter)
                            reactor.action.onNext(.selectFilter(selectedFilter))
                        } else if type == .map {
                            owner.mapSelectedIntdex = index
                            let selectedFilter = sort[index]
                            owner.appearMapView.selectFilter(selectedType: selectedFilter)
                            reactor.action.onNext(.selectFilter(selectedFilter))
                        }
                    }
                    owner.tabBarController?.presentModal(viewController, hideTabBar: true)
                case let .detail(type: type, id: id):
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
                        imageUrl: item.imageUrl,
                        background: DictionaryItemType.item.backgroundColor
                    )
                    self?.bookmarkRelay?.accept((item.monsterId, item.bookmarkId))
                case let .delete(item):
                    self?.presentDeleteSnackBar(
                        imageUrl: item.imageUrl,
                        background: DictionaryItemType.item.backgroundColor
                    )
                    self?.bookmarkRelay?.accept((item.monsterId, item.bookmarkId))
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
}
