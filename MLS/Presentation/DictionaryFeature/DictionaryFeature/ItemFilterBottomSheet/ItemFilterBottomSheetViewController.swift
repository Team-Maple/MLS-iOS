// swiftlint:disable all

import UIKit

import BaseFeature

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class ItemFilterBottomSheetViewController: BaseViewController, View {
    public typealias Reactor = ItemFilterBottomSheetReactor

    enum FilterSection: Int, CaseIterable {
        case job
        case level
        case weapons
        case projectiles
        case armors
        case accessories
        case scrollCategories
        case weaponScrolls
        case armorsScrolls
        case etcScrolls
        case etcItems

        var headerTitle: String? {
            switch self {
            case .job: return "직업"
            case .level: return "레벨"
            case .weapons: return "무기"
            case .projectiles: return "발사체"
            case .armors: return "방어구"
            case .accessories: return "장신구"
            case .scrollCategories: return "주문서"
            case .etcItems: return "기타"
            default: return nil
            }
        }

        var layout: CompositionalSectionBuilder {
            switch self {
            case .level: return LayoutFactory.getLevelRangeSection()
            case .weaponScrolls, .armorsScrolls, .etcScrolls:
                return CompositionalSectionBuilder()
                    .item(width: .fractionalWidth(0.5), height: .absolute(32))
                    .group(.horizontal, width: .fractionalWidth(1), height: .estimated(300))
                    .interItemSpacing(.fixed(3))
                    .buildSection()
                    .interGroupSpacing(16)
                    .contentInsets(.init(top: 0, leading: 16, bottom: 32, trailing: 16))
            default:
                return LayoutFactory.getItemTagListSection()
            }
        }
    }

    enum FilterItem: Hashable {
        case job(String)
        case level
        case weapons(String)
        case projectiles(String)
        case armors(String)
        case accessories(String)
        case scrollCategories(String)
        case weaponScrolls(String)
        case armorScrolls(String)
        case etcScrolls(String)
        case etcItems(String)
    }

    // Diffable Data Source 타입 정의
    typealias DataSource = UICollectionViewDiffableDataSource<FilterSection, FilterItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<FilterSection, FilterItem>

    // MARK: - Properties
    public var disposeBag = DisposeBag()
    private var isUserScrollDragging: Bool = false
    private var dataSource: DataSource! = nil
    private var mainView = ItemFilterBottomSheetView()
    private let underLineController = TabBarUnderlineController()

    public var onFilterSelected: (([(String, String)]) -> Void)?

    override public init() {
        super.init()
    }

    @available(*, unavailable)
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension ItemFilterBottomSheetViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Modal Gesture 제거
        navigationController?.presentationController?.presentedView?.gestureRecognizers?.forEach { $0.isEnabled = false }
        presentationController?.presentedView?.gestureRecognizers?.forEach { $0.isEnabled = false }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let reactor = reactor else { return }

        reactor.currentState.selectedItemIndexes.forEach { indexPath in
            let sectionCount = mainView.contentCollectionView.numberOfItems(inSection: indexPath.section)
            if indexPath.row < sectionCount {
                mainView.contentCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }

        }
        guard let selectedIndex = reactor.currentState.selectedScrollIndexes else { return }
        // 스크롤 탭(무기/방어구/기타 주문서) UI 선택 상태 복원
        let scrollCategoryIndexPath = IndexPath(row: selectedIndex, section: FilterSection.scrollCategories.rawValue)
        mainView.contentCollectionView.selectItem(at: scrollCategoryIndexPath, animated: false, scrollPosition: .centeredHorizontally)

    }
}

// MARK: - SetUp
private extension ItemFilterBottomSheetViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        configureCategoryCollectionView()
        configureContentCollectionView()
        configureSelectedItemCollectionView()
        configureDataSource()
        applyInitialSnapshot()
    }

    func configureCategoryCollectionView() {
        mainView.categoryCollectionView.collectionViewLayout = createCategoryLayout()
        mainView.categoryCollectionView.dataSource = self
        mainView.categoryCollectionView.register(PageTabbarCell.self, forCellWithReuseIdentifier: PageTabbarCell.identifier)
        underLineController.configure(with: mainView.categoryCollectionView)
    }

    func configureContentCollectionView() {
        mainView.contentCollectionView.collectionViewLayout = createContentLayout()
        mainView.contentCollectionView.register(TapButtonCell.self, forCellWithReuseIdentifier: TapButtonCell.identifier)
        mainView.contentCollectionView.register(FilterLevelSectionCell.self, forCellWithReuseIdentifier: FilterLevelSectionCell.identifier)
        mainView.contentCollectionView.register(CheckBoxButtonListSmallCell.self, forCellWithReuseIdentifier: CheckBoxButtonListSmallCell.identifier)
        mainView.contentCollectionView.register(
            SubTitleBoldHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SubTitleBoldHeaderView.identifier
        )
    }

    func configureSelectedItemCollectionView() {
        mainView.selectedItemCollectionView.collectionViewLayout = createSelectedItemLayout()
        mainView.selectedItemCollectionView.dataSource = self
        mainView.selectedItemCollectionView.register(TagChipCell.self, forCellWithReuseIdentifier: TagChipCell.identifier)
    }

    func createCategoryLayout() -> UICollectionViewLayout {
        let layout = CompositionalLayoutBuilder()
            .section { _ in LayoutFactory.getPageTabbarLayout(underLineController: underLineController) }
            .build()
        return layout
    }

    func createContentLayout() -> UICollectionViewLayout {
        let layoutAry = FilterSection.allCases.compactMap { $0.layout.build() }
        let layout = CompositionalLayoutBuilder()
            .setSections(layoutAry)
            .build()
        layout.register(Neutral200DividerView.self, forDecorationViewOfKind: Neutral200DividerView.identifier)
        return layout
    }

    func createSelectedItemLayout() -> UICollectionViewLayout {
        let layout = CompositionalLayoutBuilder()
            .section { builder in
                builder
                    .item(width: .estimated(100), height: .absolute(32))
                    .group(.horizontal, width: .estimated(100), height: .absolute(32))
                    .buildSection()
                    .interGroupSpacing(8)
                    .contentInsets(.init(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .orthogonalScrolling(.continuous)
            }
            .build()
        return layout
    }

    func configureDataSource() {
        dataSource = DataSource(collectionView: mainView.contentCollectionView) { collectionView, indexPath, item in
            switch item {
            case .job(let title), .weapons(let title), .projectiles(let title), .armors(let title),
                 .accessories(let title), .scrollCategories(let title), .etcItems(let title):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapButtonCell.identifier, for: indexPath) as! TapButtonCell
                cell.inject(title: title)
                return cell
            case .weaponScrolls(let title), .armorScrolls(let title), .etcScrolls(let title):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxButtonListSmallCell.identifier, for: indexPath) as! CheckBoxButtonListSmallCell
                cell.inject(title: title)
                return cell
            case .level:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterLevelSectionCell.identifier, for: indexPath) as! FilterLevelSectionCell
                guard let reactor = self.reactor else { return UICollectionViewCell() }
                let rowValue = cell.levelSectionView.slider.lowerValueObservable.map { Int($0) }
                let highValue = cell.levelSectionView.slider.upperValueObservable.map { Int($0) }
                Observable.combineLatest(rowValue, highValue)
                    .map { low, high in Reactor.Action.changeLevelRange(low: low, high: high) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)

                // Slider Thumb 동작 시 Scroll 비활성화
                cell.levelSectionView.slider.isThumbTracking
                    .distinctUntilChanged()
                    .withUnretained(self)
                    .subscribe { owner, isTracking in
                        owner.mainView.contentCollectionView.isScrollEnabled = !isTracking
                    }
                    .disposed(by: cell.disposeBag)
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SubTitleBoldHeaderView.identifier,
                for: indexPath
            ) as? SubTitleBoldHeaderView

            let section = FilterSection.allCases[indexPath.section]
            header?.inject(title: section.headerTitle)
            return header
        }
    }

    private func applyInitialSnapshot() {
        var snapshot = Snapshot()

        guard let reactor = reactor else { return }
        // 모든 섹션 추가
        snapshot.appendSections(FilterSection.allCases)

        // 섹션별 아이템 추가
        snapshot.appendItems(reactor.currentState.jobs.map { .job($0) }, toSection: .job)
        snapshot.appendItems([.level], toSection: .level)
        snapshot.appendItems(reactor.currentState.weapons.map { .weapons($0) }, toSection: .weapons)
        snapshot.appendItems(reactor.currentState.projectiles.map { .projectiles($0) }, toSection: .projectiles)
        snapshot.appendItems(reactor.currentState.armors.map { .armors($0) }, toSection: .armors)
        snapshot.appendItems(reactor.currentState.accessories.map { .accessories($0) }, toSection: .accessories)
        snapshot.appendItems(reactor.currentState.scrollCategories.map { .scrollCategories($0) }, toSection: .scrollCategories)
        snapshot.appendItems(reactor.currentState.weaponScrolls.map { .weaponScrolls($0) }, toSection: .weaponScrolls)
        snapshot.appendItems(reactor.currentState.armorScrolls.map { .armorScrolls($0) }, toSection: .armorsScrolls)
        snapshot.appendItems(reactor.currentState.etcScrolls.map { .etcScrolls($0) }, toSection: .etcScrolls)
        snapshot.appendItems(reactor.currentState.etcItems.map { .etcItems($0) }, toSection: .etcItems)

        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.mainView.categoryCollectionView.selectItem(at: .init(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            self?.underLineController.setInitialIndicator()
        }
    }
}

// MARK: - Methods
private extension ItemFilterBottomSheetViewController {
    func getSelectedScrollCategoryIndexPath() -> IndexPath? {
        let selectedScrollCategoryIndexPaths = getSelectedScrollCategoryIndexPaths()
        guard let selectedScrollCategoryIndexPath = selectedScrollCategoryIndexPaths.first else { return nil }
        return selectedScrollCategoryIndexPath
    }

    func getSelectedScrollCategoryIndexPaths() -> [IndexPath] {
        let indexPathsForSelectedItems = mainView.contentCollectionView.indexPathsForSelectedItems ?? []
        let selectedScrollCategoryIndexPaths = indexPathsForSelectedItems.filter { $0.section == FilterSection.scrollCategories.rawValue }
        return selectedScrollCategoryIndexPaths
    }
}

extension ItemFilterBottomSheetViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.headerView.firstIconButton.rx.tap
            .map { Reactor.Action.closeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.contentCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                guard let section = FilterSection(rawValue: indexPath.section) else { return }
                owner.mainView.contentCollectionView.isScrollEnabled = true
                switch section {
                case .scrollCategories:
                    let selectedItems = owner.getSelectedScrollCategoryIndexPaths()
                    for selectedIndexPath in selectedItems {
                        if indexPath != selectedIndexPath { owner.mainView.contentCollectionView.deselectItem(at: selectedIndexPath, animated: true) }
                    }
                    owner.reactor?.action.onNext(.filterSelected(indexPath: indexPath))
                case .weaponScrolls, .armorsScrolls, .etcScrolls:
                    let selectedItem = owner.getSelectedScrollCategoryIndexPath()
                    owner.reactor?.action.onNext(.filterSelected(indexPath: indexPath))
                    owner.mainView.contentCollectionView.selectItem(at: selectedItem, animated: false, scrollPosition: .left)
                case .level:
                    owner.mainView.contentCollectionView.deselectItem(at: indexPath, animated: true)
                default:
                    owner.reactor?.action.onNext(.filterSelected(indexPath: indexPath))
                }
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)

        mainView.contentCollectionView.rx.itemDeselected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                guard let section = FilterSection(rawValue: indexPath.section) else { return }
                switch section {
                case .weaponScrolls, .armorsScrolls, .etcScrolls:
                    let selectedItem = owner.getSelectedScrollCategoryIndexPath()
                    owner.reactor?.action.onNext(.filterDeselected(indexPath: indexPath))
                    owner.mainView.contentCollectionView.selectItem(at: selectedItem, animated: false, scrollPosition: .left)
                default:
                    reactor.action.onNext(.filterDeselected(indexPath: indexPath))
                }
            })
            .disposed(by: disposeBag)

        mainView.contentCollectionView.rx.didScroll
            .withUnretained(self)
            .subscribe { owner, _ in
                guard owner.isUserScrollDragging else { return }
                let visibleIndexPaths = owner.mainView.contentCollectionView.indexPathsForVisibleItems
                guard let topIndexPath = visibleIndexPaths.sorted(by: { $0.section < $1.section }).first,
                      let sectionMaxCount = owner.reactor?.currentState.sections.count else { return }
                var currentSection: Int = sectionMaxCount - 1
                if topIndexPath.section < sectionMaxCount { currentSection = topIndexPath.section == 0 ? 0 : topIndexPath.section - 1 }
                owner.mainView.categoryCollectionView.selectItem(
                    at: .init(row: currentSection, section: 0),
                    animated: true,
                    scrollPosition: .centeredHorizontally
                )
                owner.underLineController.animateIndicatorToSelectedItem()
            }
            .disposed(by: disposeBag)

        mainView.contentCollectionView.rx.willBeginDragging
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.isUserScrollDragging = true
            }
            .disposed(by: disposeBag)

        mainView.contentCollectionView.rx.didEndDecelerating
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.isUserScrollDragging = false
            }
            .disposed(by: disposeBag)

        mainView.categoryCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                owner.mainView.categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                let section = indexPath.row == 6 ? 10 : indexPath.row == 0 ? 0 : indexPath.row + 1
                owner.underLineController.animateIndicatorToSelectedItem()
                owner.mainView.contentCollectionView.scrollToItem(at: .init(row: 0, section: section), at: .top, animated: true)
            }
            .disposed(by: disposeBag)

        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        mainView.contentCollectionView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)

        mainView.clearButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // Reactor에 액션 전달
                owner.reactor?.action.onNext(.resetFilters)

                // UI에서 직접 deselect
                owner.mainView.contentCollectionView.indexPathsForSelectedItems?.forEach {
                    owner.mainView.contentCollectionView.deselectItem(at: $0, animated: false)
                }
            })
            .disposed(by: disposeBag)

        mainView.headerView.firstIconButton.rx.tap
            .map { Reactor.Action.closeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.applyButton.rx.tap
            .withUnretained(self)
            .compactMap { _, _ in

                let state = reactor.currentState

                var selectedItems: [(String, String)] = []

                for indexPath in state.selectedItemIndexes {
                    guard let section = ItemFilterBottomSheetViewController.FilterSection(rawValue: indexPath.section) else { continue }

                    switch section {
                    case .level:
                        selectedItems.append(("레벨", "레벨 \(state.levelRange.low) ~ \(state.levelRange.high)"))
                    case .job:
                        selectedItems.append(("직업", state.jobs[indexPath.row]))
                    case .weapons:
                        selectedItems.append(("무기", state.weapons[indexPath.row]))
                    case .projectiles:
                        selectedItems.append(("발사체", state.projectiles[indexPath.row]))
                    case .armors:
                        selectedItems.append(("방어구", state.armors[indexPath.row]))
                    case .accessories:
                        selectedItems.append(("장신구", state.accessories[indexPath.row]))
                    case .scrollCategories:
                        selectedItems.append(("주문서", state.scrollCategories[indexPath.row]))
                    case .weaponScrolls:
                        // 기존 방식대로 하게 되면 주문서 탭 변경시 각 scrolls가 빈배열 처리되서 오류
                        selectedItems.append(("무기주문서", state.originWeaponScrolls[indexPath.row]))
                    case .armorsScrolls:
                        selectedItems.append(("방어구주문서", state.originArmorScrolls[indexPath.row]))
                    case .etcScrolls:
                        selectedItems.append(("기타주문서", state.originEtcScrolls[indexPath.row]))
                    case .etcItems:
                        selectedItems.append(("기타아이템", state.etcItems[indexPath.row]))
                    }
                }
                return Reactor.Action.applyButtonTapped(selectedItems)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map { (scrollTypes: $0.scrollCategories, weaponScrolls: $0.weaponScrolls, armorScrolls: $0.armorScrolls, etcScrolls: $0.etcScrolls) }
            .distinctUntilChanged { $0 == $1 }
            .skip(1)
            .withUnretained(self)
            .subscribe { owner, scrolls in
                guard let dataSource = owner.dataSource else { return }
                var snapshot = dataSource.snapshot()
                snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .scrollCategories))
                snapshot.appendItems(scrolls.scrollTypes.map { .scrollCategories($0) }, toSection: .scrollCategories)
                snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .weaponScrolls))
                snapshot.appendItems(scrolls.weaponScrolls.map { .weaponScrolls($0) }, toSection: .weaponScrolls)
                snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .armorsScrolls))
                snapshot.appendItems(scrolls.armorScrolls.map { .armorScrolls($0) }, toSection: .armorsScrolls)
                snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .etcScrolls))
                snapshot.appendItems(scrolls.etcScrolls.map { .etcScrolls($0) }, toSection: .etcScrolls)
                owner.dataSource.apply(snapshot, animatingDifferences: false) {

                    guard let selectedItem = owner.getSelectedScrollCategoryIndexPath() else { return }
                    var targetIndexPath: [IndexPath] = []
                    switch selectedItem.row {
                    case 0:
                        targetIndexPath = owner.reactor?.currentState.selectedItemIndexes.filter { FilterSection(rawValue: $0.section) == .weaponScrolls } ?? []
                    case 1:
                        targetIndexPath = owner.reactor?.currentState.selectedItemIndexes.filter { FilterSection(rawValue: $0.section) == .armorsScrolls } ?? []
                    case 2:
                        targetIndexPath = owner.reactor?.currentState.selectedItemIndexes.filter { FilterSection(rawValue: $0.section) == .etcScrolls } ?? []
                    default:
                        break
                    }
                    for target in targetIndexPath {
                        let count = owner.mainView.contentCollectionView.numberOfItems(inSection: target.section)
                        if count > target.row {
                            owner.mainView.contentCollectionView.selectItem(at: target, animated: true, scrollPosition: .left)
                        }
                    }

                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.selectedItemIndexes }
            .withUnretained(self)
            .subscribe { owner, indexPaths in
                owner.mainView.selectedItemCollectionView.isHidden = indexPaths.isEmpty
                owner.mainView.selectedItemCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        rx.viewDidLoad
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .subscribe { [weak self] route in
                guard let self = self else { return }
                switch route {
                case .dismiss:
                    self.dismiss(animated: true)
                case .dismissWithSelection(let selectedItems):
                    self.onFilterSelected?(selectedItems)
                    self.dismiss(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

extension ItemFilterBottomSheetViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        if collectionView == mainView.categoryCollectionView {
            return reactor.currentState.sections.count
        } else {
            return reactor.currentState.selectedItemIndexes.count
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reactor = reactor else { return UICollectionViewCell() }
        if collectionView == mainView.categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageTabbarCell.identifier, for: indexPath) as! PageTabbarCell
            let title = reactor.currentState.sections[indexPath.row]
            cell.inject(title: title)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagChipCell.identifier, for: indexPath) as! TagChipCell
            let titles = reactor.currentState.selectedItemIndexes.map { indexPath -> String in
                guard let section = ItemFilterBottomSheetViewController.FilterSection(rawValue: indexPath.section) else { return "" }
                switch section {
                case .job:
                    return reactor.currentState.jobs[indexPath.row]
                case .weapons:
                    return reactor.currentState.weapons[indexPath.row]
                case .projectiles:
                    return reactor.currentState.projectiles[indexPath.row]
                case .armors:
                    return reactor.currentState.armors[indexPath.row]
                case .accessories:
                    return reactor.currentState.accessories[indexPath.row]
                case .weaponScrolls:
                    return reactor.currentState.originWeaponScrolls[indexPath.row]
                case .armorsScrolls:
                    return reactor.currentState.originArmorScrolls[indexPath.row]
                case .etcScrolls:
                    return reactor.currentState.originEtcScrolls[indexPath.row]
                case .etcItems:
                    return reactor.currentState.etcItems[indexPath.row]
                case .level:
                    let range = reactor.currentState.levelRange
                    return "\(range.low) ~ \(range.high)"
                default:
                    return ""
                }
            }
            cell.inject(title: titles[indexPath.row], style: .normal)
            cell.button.cancelButton.rx.tap
                .withUnretained(self)
                .subscribe { owner, _ in
                    let deselectedIndex = reactor.currentState.selectedItemIndexes[indexPath.row]
                    let section = FilterSection(rawValue: deselectedIndex.section)
                    switch section {
                    case .level:
                        if let cell = owner.mainView.contentCollectionView.cellForItem(at: deselectedIndex) as? FilterLevelSectionCell {
                            cell.levelSectionView.slider.lowerValue = 0
                            cell.levelSectionView.slider.upperValue = 200
                            owner.reactor?.action.onNext(.changeLevelRange(low: 0, high: 200))
                        }
                        owner.reactor?.action.onNext(.filterDeselected(indexPath: deselectedIndex))
                    case .weaponScrolls, .armorsScrolls, .etcScrolls:
                        let selectedItem = owner.getSelectedScrollCategoryIndexPath()
                        owner.reactor?.action.onNext(.filterDeselected(indexPath: deselectedIndex))
                        owner.mainView.contentCollectionView.deselectItem(at: deselectedIndex, animated: false)
                        owner.mainView.contentCollectionView.selectItem(at: selectedItem, animated: false, scrollPosition: .left)
                    default:
                        owner.mainView.contentCollectionView.deselectItem(at: deselectedIndex, animated: true)
                        owner.reactor?.action.onNext(.filterDeselected(indexPath: deselectedIndex))
                    }
                }
                .disposed(by: cell.disposeBag)
            return cell
        }
    }
}
