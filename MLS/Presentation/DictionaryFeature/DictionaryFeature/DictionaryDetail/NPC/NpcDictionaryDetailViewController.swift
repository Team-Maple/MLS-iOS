import UIKit

import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

final class NpcDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = NpcDictionaryDetailReactor

    // MARK: - Componenets
    private var appearMapView = DetailStackCardView()
    private var questView = DetailStackCardView()
    private let sortedFactory: SortedBottomSheetFactory = SortedBottomSheetFactoryImpl()
}

// MARK: - SetUp
private extension NpcDictionaryDetailViewController {
    // 매개변수로 넘겨주는 것과
    func setUpMainInfo(name: String, imageUrl: String?) {
        // 상세정보(메인)
        inject(
            input: DictionaryDetailBaseViewController
                .Input(
                    imageUrl: imageUrl,
                    backgroundColor: type.backgroundColor,
                    name: name,
                    subText: ""
                )
        )
    }

    // 내부에서 리액터 사용해서 하는 것
    func setUpMapView() {
        guard let reactor = reactor else { return }
        let maps = reactor.currentState.maps

        appearMapView.reset()
        contentViews.append(appearMapView)
        if maps.isEmpty {
            // 출현맵
            contentViews[0] = DetailEmptyView(type: .appearMap)
        } else {
            contentViews[0] = appearMapView
            for map in maps {
                appearMapView.inject(input: DetailStackCardView.Input(
                    type: .appearMap,
                    imageUrl: map.iconUrl,
                    mainText: map.mapName,
                    subText: map.detailName
                ))
            }
        }
    }

    func setUpQuestView() {
        guard let reactor = reactor,
              let filter = reactor.currentState.questFilter.first else { return }

        questView.initFilter(firstFilter: filter)

        let quests = reactor.currentState.quests
        questView.reset()
        contentViews.append(questView)
        if quests.isEmpty {
            // 퀘스트
            contentViews[1] = DetailEmptyView(type: .quest)
        } else {
            contentViews[1] = questView
            for quest in quests {
                questView.inject(input: DetailStackCardView.Input(
                    type: .quest,
                    imageUrl: quest.questIconUrl,
                    mainText: quest.questNameKr
                ))
            }
        }
    }
}

// MARK: - Bind
extension NpcDictionaryDetailViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
        bindReportButton(providerId: reactor.state.map { $0.id }, itemName: reactor.state.map { $0.npcDetailInfo.nameKr })
    }

    private func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        questView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        questView.tap
            .map { Reactor.Action.questTapped(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        appearMapView.tap
            .map { Reactor.Action.mapTapped(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) } // 값이 바뀔때만 이벤트 받음
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .filter(let type):
                    let viewController = owner.sortedFactory.make(sortedOptions: type, selectedIndex: owner.selectedIndex) { index in
                        owner.selectedIndex = index
                        let selectedFilter = type[index]
                        owner.questView.selectFilter(selectedType: selectedFilter)
                        reactor.action.onNext(.selectFilter(selectedFilter))
                    }
                    owner.tabBarController?.presentModal(viewController, hideTabBar: true)
                case .detail(type: let type, id: let id):
                    let viewController = owner.dictionaryDetailFactory.make(type: type, id: id)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state.map(\.npcDetailInfo)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, map in
                owner.setUpMainInfo(name: map.nameKr, imageUrl: map.iconUrlDetail)
                owner.mainView.setBookmark(isBookmarked: map.bookmarkId != nil)
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.maps)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.setUpMapView()
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.quests)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.setUpQuestView()
            })
            .disposed(by: disposeBag)

        bindBookmarkButton(
            buttonTap: mainView.bookmarkButton.rx.tap,
            currentItem: reactor.state.map { $0.npcDetailInfo },
            isLogin: { reactor.currentState.isLogin },
            imageUrl: { $0.iconUrlDetail },
            backgroundColor: type.backgroundColor,
            isBookmarked: { $0.bookmarkId != nil },
            toggleBookmark: { isDeleting in reactor.action.onNext(.toggleBookmark(isDeleting)) },
            undoLastDeleted: { reactor.action.onNext(.undoLastDeletedBookmark) },
            bookmarkId: reactor.state.map(\.npcDetailInfo.bookmarkId)
        )
        .disposed(by: disposeBag)
    }
}
