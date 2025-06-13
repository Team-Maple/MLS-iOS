import UIKit

import BaseFeature

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final public class ItemFilterBottomSheetViewController: BaseViewController, View {

    public typealias Reactor = ItemFilterBottomSheetViewReactor

    enum Section: Int, CaseIterable {
        case job
        case level
        case weapons
        case projectiles
        case armors
        case accessories
        case scrollTypes
        case scrolls
        case etcItems
        
        var headerTitle: String? {
            switch self {
            case .job:
                return "직업"
            case .level:
                return "레벨"
            case .weapons:
                return "무기"
            case .projectiles:
                return "발사체"
            case .armors:
                return "방어구"
            case .accessories:
                return "장신구"
            case .scrollTypes:
                return "주문서"
            case .etcItems:
                return "기타"
            default:
                return nil
            }
        }
        
        var layout: CompositionalSectionBuilder {
            switch self {
            case .level:
                return LayoutFactory.getLevelRangeSection()
            case .scrolls:
                return CompositionalSectionBuilder()
                    .item(width: .fractionalWidth(0.5), height: .absolute(32))
                    .group(.horizontal, width: .fractionalWidth(1), height: .estimated(300))
                    .interItemSpacing(.fixed(3))
                    .buildSection()
                    .interGroupSpacing(16)
                    .contentInsets(.init(top: 0, leading: 16, bottom: 32, trailing: 16))
                    .decorationItem(kind: Neutral200DividerView.identifier, insets: .init(top: -20, leading: 16, bottom: 0, trailing: 16))
            default:
                return LayoutFactory.getItemTagListSection()
            }
        }
    }

    private var isScroll: Bool = false

    private var lastSelectedSection: Section = .job
    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private var mainView = ItemFilterBottomSheetView()

    public override init() {
        super.init()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension ItemFilterBottomSheetViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
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
    }

    func configureCategoryCollectionView() {
        mainView.categoryCollectionView.collectionViewLayout = createCategoryLayout()
        mainView.categoryCollectionView.dataSource = self
        mainView.categoryCollectionView.register(PageTabbarCell.self, forCellWithReuseIdentifier: PageTabbarCell.identifier)
        mainView.categoryCollectionView.selectItem(at: .init(row: 0, section: 0), animated: false, scrollPosition: .bottom)
    }

    func configureContentCollectionView() {
        mainView.contentCollectionView.collectionViewLayout = createContentLayout()
        mainView.contentCollectionView.dataSource = self
        mainView.contentCollectionView.register(TapButtonCell.self, forCellWithReuseIdentifier: TapButtonCell.identifier)
        mainView.contentCollectionView.register(FilterLevelSectionCell.self, forCellWithReuseIdentifier: FilterLevelSectionCell.identifier)
        mainView.contentCollectionView.register(CheckBoxButtonListSmallCell.self, forCellWithReuseIdentifier: CheckBoxButtonListSmallCell.identifier)
        mainView.contentCollectionView.register(
            SubTitleBoldHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SubTitleBoldHeaderView.identifier
        )
    }

    func createCategoryLayout() -> UICollectionViewLayout {
        let layout = CompositionalLayoutBuilder()
            .section { _ in return LayoutFactory.getPageTabbarLayout() }
            .build()
        layout.register(Neutral300DividerView.self, forDecorationViewOfKind: Neutral300DividerView.identifier)
        return layout
    }

    func createContentLayout() -> UICollectionViewLayout {
        let layoutAry = Section.allCases.compactMap { $0.layout.build() }
        let layout = CompositionalLayoutBuilder()
            .setSections(layoutAry)
            .build()
        layout.register(Neutral200DividerView.self, forDecorationViewOfKind: Neutral200DividerView.identifier)
        return layout
    }
}

extension ItemFilterBottomSheetViewController {
    
    private func bind() {
        mainView.categoryCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { (owner, indexPath) in
                guard let selectedSection = Section(rawValue: indexPath.row) else { return }
                owner.isScroll = true
                switch owner.lastSelectedSection {
                case .armors, .accessories, .scrollTypes, .etcItems:
                    switch selectedSection {
                    case .armors, .accessories, .scrollTypes, .etcItems:
                        owner.isScroll = false
                    default:
                        owner.mainView.contentCollectionView.scrollToItem(at: .init(row: 0, section: indexPath.row), at: .top, animated: true)
                    }
                default:
                    owner.mainView.contentCollectionView.scrollToItem(at: .init(row: 0, section: indexPath.row), at: .top, animated: true)
                }
                owner.lastSelectedSection = selectedSection
                owner.mainView.categoryCollectionView.collectionViewLayout.invalidateLayout()
            }
            .disposed(by: disposeBag)
        
        mainView.contentCollectionView.rx.didScroll
            .withUnretained(self)
            .subscribe { (owner, _) in
                guard !owner.isScroll else { return }
                let visibleIndexPaths = owner.mainView.contentCollectionView.indexPathsForVisibleItems
                guard let topIndexPath = visibleIndexPaths.sorted(by: { $0.section < $1.section || ($0.section == $1.section && $0.row < $1.row) }).first else { return }
                let currentSection = topIndexPath.section
                if let selectedSection = Section(rawValue: currentSection) {
                    owner.lastSelectedSection = selectedSection
                }
                owner.mainView.categoryCollectionView.selectItem(
                    at: IndexPath(row: currentSection, section: 0),
                    animated: false,
                    scrollPosition: .centeredHorizontally
                )
                owner.mainView.categoryCollectionView.collectionViewLayout.invalidateLayout()
            }
            .disposed(by: disposeBag)
        
        mainView.contentCollectionView.rx.didEndScrollingAnimation
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.isScroll = false
            }
            .disposed(by: disposeBag)
        
        mainView.contentCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe { (owner, indexPath) in
                print(owner.mainView.contentCollectionView.indexPathsForSelectedItems)
            }
            .disposed(by: disposeBag)
    }

    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
        bind()
    }

    func bindUserActions(reactor: Reactor) {
        mainView.headerView.firstIconView.rx.tap
            .map { Reactor.Action.closeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in return reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { (owner, route) in
                switch route {
                case .dismiss:
                    owner.dismiss(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

extension ItemFilterBottomSheetViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == mainView.categoryCollectionView {
            return 1
        } else {
            return Section.allCases.count
        }
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        if collectionView == mainView.categoryCollectionView {
            return reactor.currentState.sections.count
        } else {
            switch Section(rawValue: section)! {
            case .job:
                return reactor.currentState.jobs.count
            case .level:
                return 1
            case .weapons:
                return reactor.currentState.weapons.count
            case .projectiles:
                return reactor.currentState.projectiles.count
            case .armors:
                return reactor.currentState.armors.count
            case .accessories:
                return reactor.currentState.accessories.count
            case .scrollTypes:
                return reactor.currentState.scrolls.count
            case .etcItems:
                return reactor.currentState.etcItems.count
            case .scrolls:
                return 10
            }
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reactor = reactor else { return UICollectionViewCell() }
        if collectionView == mainView.categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageTabbarCell.identifier, for: indexPath) as? PageTabbarCell else {
                return UICollectionViewCell()
            }
            let title = reactor.currentState.sections[indexPath.row]
            cell.inject(title: title)
            return cell
        } else {
            switch Section(rawValue: indexPath.section)! {
            case .job:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapButtonCell.identifier, for: indexPath) as? TapButtonCell else {
                    return UICollectionViewCell()
                }
                let job = reactor.currentState.jobs[indexPath.row]
                cell.inject(title: job)
                return cell
            case .level:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterLevelSectionCell.identifier, for: indexPath) as? FilterLevelSectionCell else {
                    return UICollectionViewCell()
                }
                return cell
            case .weapons:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapButtonCell.identifier, for: indexPath) as? TapButtonCell else {
                    return UICollectionViewCell()
                }
                let weapons = reactor.currentState.weapons[indexPath.row]
                cell.inject(title: weapons)
                return cell
            case .projectiles:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapButtonCell.identifier, for: indexPath) as? TapButtonCell else {
                    return UICollectionViewCell()
                }
                let projectiles = reactor.currentState.projectiles[indexPath.row]
                cell.inject(title: projectiles)
                return cell
            case .armors:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapButtonCell.identifier, for: indexPath) as? TapButtonCell else {
                    return UICollectionViewCell()
                }
                let armors = reactor.currentState.armors[indexPath.row]
                cell.inject(title: armors)
                return cell
            case .accessories:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapButtonCell.identifier, for: indexPath) as? TapButtonCell else {
                    return UICollectionViewCell()
                }
                let accessories = reactor.currentState.accessories[indexPath.row]
                cell.inject(title: accessories)
                return cell
            case .scrollTypes:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapButtonCell.identifier, for: indexPath) as? TapButtonCell else {
                    return UICollectionViewCell()
                }
                let scrolls = reactor.currentState.scrolls[indexPath.row]
                cell.inject(title: scrolls)
                return cell
            case .scrolls:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxButtonListSmallCell.identifier, for: indexPath) as? CheckBoxButtonListSmallCell else {
                    return UICollectionViewCell()
                }
//                let scrolls = reactor.currentState.scrolls[indexPath.row]
//                cell.inject(title: scrolls)
                cell.inject(title: "한손검")
                return cell
            case .etcItems:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapButtonCell.identifier, for: indexPath) as? TapButtonCell else {
                    return UICollectionViewCell()
                }
                let etcItems = reactor.currentState.etcItems[indexPath.row]
                cell.inject(title: etcItems)
                return cell
            }
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SubTitleBoldHeaderView.identifier,
            for: indexPath
        ) as? SubTitleBoldHeaderView else {
            return UICollectionReusableView()
        }

        // ✅ 섹션별로 제목 설정
        let headerTitle = Section(rawValue: indexPath.section)?.headerTitle
        headerView.inject(title: headerTitle)
        return headerView
    }
}
