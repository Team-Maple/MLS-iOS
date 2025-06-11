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
        case weapons
        case projectiles
        case armors
        case accessories
        case scrolls
        case etcItems

        var headerTitle: String {
            switch self {
            case .job:
                "직업"
            case .weapons:
                "무기"
            case .projectiles:
                "발사체"
            case .armors:
                "방어구"
            case .accessories:
                "장신구"
            case .scrolls:
                "주문서"
            case .etcItems:
                "기타"
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
        mainView.categoryCollectionView.delegate = self
        mainView.categoryCollectionView.dataSource = self
        mainView.categoryCollectionView.register(PageTabbarCell.self, forCellWithReuseIdentifier: PageTabbarCell.identifier)
        mainView.categoryCollectionView.selectItem(at: .init(row: 0, section: 0), animated: false, scrollPosition: .bottom)
    }

    func configureContentCollectionView() {
        mainView.contentCollectionView.collectionViewLayout = createContentLayout()
        mainView.contentCollectionView.delegate = self
        mainView.contentCollectionView.dataSource = self
        mainView.contentCollectionView.register(TapButtonCell.self, forCellWithReuseIdentifier: TapButtonCell.identifier)
        mainView.contentCollectionView.register(
            SubTitleBoldHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SubTitleBoldHeaderView.identifier
        )
    }

    func createCategoryLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in return layoutFactory.getPageTabbarLayout() }
            .build()
        layout.register(PageTabbarDividerView.self, forDecorationViewOfKind: PageTabbarDividerView.identifier)
        return layout
    }

    func createContentLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in return layoutFactory.getItemTagListSection() }
            .section { _ in return layoutFactory.getItemTagListSection() }
            .section { _ in return layoutFactory.getItemTagListSection() }
            .section { _ in return layoutFactory.getItemTagListSection() }
            .section { _ in return layoutFactory.getItemTagListSection() }
            .section { _ in return layoutFactory.getItemTagListSection() }
            .section { _ in return layoutFactory.getItemTagListSection() }
            .build()
        return layout
    }
}

extension ItemFilterBottomSheetViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
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

extension ItemFilterBottomSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
            case .weapons:
                return reactor.currentState.weapons.count
            case .projectiles:
                return reactor.currentState.projectiles.count
            case .armors:
                return reactor.currentState.armors.count
            case .accessories:
                return reactor.currentState.accessories.count
            case .scrolls:
                return reactor.currentState.scrolls.count
            case .etcItems:
                return reactor.currentState.etcItems.count
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
            cell.configure(title: title)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TapButtonCell.identifier, for: indexPath) as? TapButtonCell else {
                return UICollectionViewCell()
            }
            switch Section(rawValue: indexPath.section)! {
            case .job:
                let job = reactor.currentState.jobs[indexPath.row]
                cell.configure(title: job)
            case .weapons:
                let weapons = reactor.currentState.weapons[indexPath.row]
                cell.configure(title: weapons)
            case .projectiles:
                let projectiles = reactor.currentState.projectiles[indexPath.row]
                cell.configure(title: projectiles)
            case .armors:
                let armors = reactor.currentState.armors[indexPath.row]
                cell.configure(title: armors)
            case .accessories:
                let accessories = reactor.currentState.accessories[indexPath.row]
                cell.configure(title: accessories)
            case .scrolls:
                let scrolls = reactor.currentState.scrolls[indexPath.row]
                cell.configure(title: scrolls)
            case .etcItems:
                let etcItems = reactor.currentState.etcItems[indexPath.row]
                cell.configure(title: etcItems)
            }
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.categoryCollectionView {
            guard let selectedSection = Section(rawValue: indexPath.row) else { return }
            isScroll = true
            switch lastSelectedSection {
            case .armors, .accessories, .scrolls, .etcItems:
                switch selectedSection {
                case .armors, .accessories, .scrolls, .etcItems:
                    isScroll = false
                default:
                    mainView.contentCollectionView.scrollToItem(at: .init(row: 0, section: indexPath.row), at: .top, animated: true)
                }
            default:
                mainView.contentCollectionView.scrollToItem(at: .init(row: 0, section: indexPath.row), at: .top, animated: true)
            }
            lastSelectedSection = selectedSection
            collectionView.collectionViewLayout.invalidateLayout()
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
        headerView.configure(title: headerTitle)
        return headerView
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isScroll else { return }
        let visibleIndexPaths = mainView.contentCollectionView.indexPathsForVisibleItems
        guard let topIndexPath = visibleIndexPaths.sorted(by: { $0.section < $1.section || ($0.section == $1.section && $0.row < $1.row) }).first else {
            return
        }
        let currentSection = topIndexPath.section
        if let selectedSection = Section(rawValue: currentSection) {
            lastSelectedSection = selectedSection
        }
        mainView.categoryCollectionView.selectItem(
            at: IndexPath(row: currentSection, section: 0),
            animated: false,
            scrollPosition: .centeredHorizontally
        )
        mainView.categoryCollectionView.collectionViewLayout.invalidateLayout()
    }

    // ✅ 스크롤 애니메이션이 끝나면 다시 플래그 해제
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == mainView.contentCollectionView {
            isScroll = false
        }
    }
}
