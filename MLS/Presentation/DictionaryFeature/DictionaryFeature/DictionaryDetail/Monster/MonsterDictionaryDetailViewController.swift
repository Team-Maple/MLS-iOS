import UIKit

import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

class MonsterDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MonsterDictionaryDetailReactor

    // MARK: - Properties
    private var selectedIndex = 0
    private var dropItemSelectedIndex = 0
    private var mapSelectedIntdex = 0

    // MARK: - Componenets
    private var detailView = DetailStackInfoView(type: .monster)
    private var appearMapView = DetailStackCardView()
    private var dropItemView = DetailStackCardView()
    private let sortedFactory: SortedBottomSheetFactory = SortedBottomSheetFactoryImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .monster
        setUpMapView()
    }
}

// MARK: - Populate Data
private extension MonsterDictionaryDetailViewController {
    func setUpMainInfo(name: String, subText: String) {
        // 상세정보
        inject(
            input: DictionaryDetailBaseViewController
                .Input(
                    image: DesignSystemAsset.image(named: "testImage"),
                    backgroundColor: type.backgroundColor,
                    name: name,
                    subText: subText
                )
        )
    }

    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.menus.infos
        
        contentViews.append(detailView)
        
        for info in infos {
            detailView.addInfo(mainText: info.name, subText: info.desc)
        }
    }
    
    func setUpMapView() {
        guard let reactor = reactor else { return }
        let maps = reactor.currentState.menus.maps
        if maps.isEmpty {
            contentViews.append(DetailEmptyView(type: .appearMap))
        } else {
            contentViews.append(appearMapView)
            appearMapView.filterButton.setAttributedTitle(.makeStyledString(font: .b_s_r, text: "출현 많은 순", color: .primary700), for: .normal)
            appearMapView.filterButton.tintColor = .primary700
            
            for map in maps {
                appearMapView.inject(input: DetailStackCardView
                    .Input(
                        type: .appearMonsterWithText,
                        imageUrl: map.iconUrl,
                        mainText: map.mapName,
                        subText: map.regionName,
                        additionalText: "\(map.maxSpawnCount)마리"
                    )
                )
            }
        }
    }

    func setUpDropItemView() {
        guard let reactor = reactor else { return }
        let items = reactor.currentState.menus.items
        // 드롭아이템
        if items.isEmpty {
            contentViews.append(DetailEmptyView(type: .dropItemWithText))
        } else {
            contentViews.append(dropItemView)
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
    }

    private func bindcUserActions(reactor: Reactor) {
        dropItemView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped(.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        appearMapView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped(.map) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        let selectedFilter = reactor.currentState.type.detailSortedFilter[selectedIndex]
        dropItemView.selectFilter(selectedType: selectedFilter)
        
        isBottomTabbarHidden = true
        
        reactor.state.map(\.tags)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] tags in
                self?.makeTagsRow(tags)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.name)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.setUpMainInfo(name: reactor.currentState.name, subText: "\(reactor.currentState.level)")
            })
            .disposed(by: disposeBag)
        reactor.state.map(\.menus.infos)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.setUpInfoStackView()
            })
            .disposed(by: disposeBag)
        reactor.state.map(\.menus.maps)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.setUpMapView()
            })
            .disposed(by: disposeBag)
        reactor.state.map(\.menus.items)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.setUpDropItemView()
            })
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) } // 값이 바뀔때만 이벤트 받음
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .filter(let type):
                    let selectedIndex = (type == .item) ? owner.dropItemSelectedIndex : owner.mapSelectedIntdex
                    
                    let viewController = owner.sortedFactory.make(sortedOptions: type.detailSortedFilter, selectedIndex: selectedIndex) { index in
                        if type == .item {
                            owner.dropItemSelectedIndex = index
                            let selectedFilter = type.detailSortedFilter[index]
                            owner.dropItemView.selectFilter(selectedType: selectedFilter)
                        } else if type == .map {
                            owner.mapSelectedIntdex = index
                            let selectedFilter = type.detailSortedFilter[index]
                            print("selectedFilter: \(selectedFilter)")
                            owner.appearMapView.selectFilter(selectedType: selectedFilter)
                        }
                        owner.isBottomTabbarHidden = true
                    }
                    owner.tabBarController?.presentModal(viewController)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .take(1)
            .subscribe { _ in
                // TODO: 디테일 API 호출
                reactor.action.onNext(.viewWillAppear)
            }
            .disposed(by: disposeBag)
    }
}
