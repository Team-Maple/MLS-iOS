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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainInfo()
        setUpMapView()
        setUpQuestView()
    }

    init(imageUrl: String) {
        super.init(type: .npc)
    }
}

// MARK: - SetUp
private extension NpcDictionaryDetailViewController {
    func setUpMainInfo() {
        // 상세정보(메인?)
        self.inject(
            input: DictionaryDetailBaseViewController
                .Input(
                    image: .add,
                    backgroundColor: type.backgroundColor,
                    name: "뇌전수리검",
                    subText: "Lv10"
                )
        )
    }
    func setUpMapView() {
        // 데이터 유효성 검증
        if true {
            contentViews.append(appearMapView)
            // 카드 개수만큼 반복
            for _ in 0...5 {
                appearMapView
                    .inject(
                        input: DetailStackCardView
                            .Input(
                                type: .appearMap,
                                imageUrl: "testImage",
                                mainText: "시간의 지평선",
                                subText: "카테고리(커닝시티 등)"
                            )
                    )
            }
        } else {
            contentViews.append(DetailEmptyView(type: .appearMap))
        }
    }

    func setUpQuestView() {
        // 데이터 유효성 검증
        if false {
            contentViews.append(questView)
            // 카드 개수만큼 반복
            for _ in 0...5 {
                questView
                    .inject(
                        input: DetailStackCardView
                            .Input(
                                type: .quest,
                                imageUrl: "tesetImage",
                                mainText: "퀘스트 이름",
                                subText: "수락 Lv. 21"
                            )
                    )
            }
        } else {
            contentViews.append(DetailEmptyView(type: .quest))
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
                    }
                    owner.tabBarController?.presentModal(viewController)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
