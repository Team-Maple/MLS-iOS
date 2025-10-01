import UIKit

import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

class MonsterDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MonsterDictionaryDetailReactor

    // MARK: - Componenets
    private var detailView = DetailStackInfoView(type: .monster)
    private var appearMapView = DetailStackMapView(imageUrl: "")
    private var dropItemView = DetailStackCardView()
    private let sortedFactory: SortedBottomSheetFactory = SortedBottomSheetFactoryImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .monster
        setUpMainInfo()
        setUpInfoStackView()
        setUpMapView()
        setUpDropItemView()
    }
}

// MARK: - Populate Data
private extension MonsterDictionaryDetailViewController {
    func setUpMainInfo() {
        // 상세정보
        inject(
            input: DictionaryDetailBaseViewController
                .Input(
                    image: DesignSystemAsset.image(named: "testImage"),
                    backgroundColor: type.backgroundColor,
                    name: "다크 주니어 예티와 페페",
                    subText: "Lv21"
                )
        )
    }

    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.menus.infos

        if !infos.isEmpty {
            contentViews.append(detailView)
            for info in infos {
                detailView.addInfo(mainText: info.name, subText: info.desc)
            }
        } else {
            contentViews.append(DetailEmptyView(type: .normal))
        }
    }

    func setUpMapView() {
        if true {
            // 드롭아이템
            contentViews.append(appearMapView)
        } else {
            contentViews.append(DetailEmptyView(type: .appearMapWithText))
        }
    }

    func setUpDropItemView() {
        guard let reactor = reactor,
              let filter = reactor.currentState.type.detailSortedFilter.first else { return }
        dropItemView.initFilter(firstFilter: filter)
        
        if true {
            // 드롭아이템
            contentViews.append(dropItemView)
            dropItemView
                .inject(
                    input: DetailStackCardView
                        .Input(
                            type: .dropItemWithText,
                            imageUrl: "imageUrl",
                            mainText: "뇌전수리검",
                            subText: "Lv.21",
                            additionalText: "0.001%"
                        )
                )
        } else {
            contentViews.append(DetailEmptyView(type: .dropItemWithText))
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
        dropItemView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.tags)
            .distinctUntilChanged() // tag는 변경될 때만 이벤트 받기
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] tags in
                self?.makeTagsRow(tags)
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) } // 값이 바뀔때만 이벤트 받음
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .filter(let type):
                    let viewController = owner.sortedFactory.make(sortedOptions: type.detailSortedFilter, selectedIndex: owner.selectedIndex) { index in
                        owner.selectedIndex = index
                        let selectedFilter = reactor.currentState.type.detailSortedFilter[index]
                        owner.dropItemView.selectFilter(selectedType: selectedFilter)
                        self.isBottomTabbarHidden = true
                    }
                    owner.tabBarController?.presentModal(viewController)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
