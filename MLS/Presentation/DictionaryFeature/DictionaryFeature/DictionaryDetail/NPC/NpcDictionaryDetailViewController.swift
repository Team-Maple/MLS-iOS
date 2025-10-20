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

    init(imageUrl: String) {
        super.init(type: .npc)
    }
}

// MARK: - SetUp
private extension NpcDictionaryDetailViewController {
    // 매개변수로 넘겨주는 것과
    func setUpMainInfo(name: String, imageUrl: String?) {
        // 상세정보(메인)
        self.inject(
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
                    subText: map.detailName))
            }
        }

    }

    func setUpQuestView() {
        guard let reactor = reactor else { return }
        let quests = reactor.currentState.quests
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
    }

    private func bindUserActions(reactor: Reactor) {
        questView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        let selectedFilter = reactor.currentState.type.detailSortedFilter[selectedIndex]
        questView.selectFilter(selectedType: selectedFilter)
        isBottomTabbarHidden = true

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
                        owner.questView.selectFilter(selectedType: selectedFilter)
                        reactor.action.onNext(.selectFilter(selectedFilter))
                    }
                    owner.tabBarController?.presentModal(viewController)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        reactor.state.map(\.info)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] info in
                self?.setUpMainInfo(name: info.name, imageUrl: info.imgUrl)
            })
            .disposed(by: disposeBag)
        reactor.state.map(\.maps)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.setUpMapView()
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.quests)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.setUpQuestView()
            })
            .disposed(by: disposeBag)

        rx.viewWillAppear
            .take(1)
            .subscribe { _ in
                reactor.action.onNext(.viewWillAppear)
            }
            .disposed(by: disposeBag)
    }
}
