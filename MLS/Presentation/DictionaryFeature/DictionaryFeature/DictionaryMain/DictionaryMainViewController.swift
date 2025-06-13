import UIKit

import BaseFeature
import DesignSystem

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class DictionaryMainViewController: BaseViewController, View {
    public typealias Reactor = DictionaryMainReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()
    private let initialIndex: Int
    private lazy var currentPageIndex = BehaviorRelay<Int>(value: initialIndex)
        
    private var viewControllers: [UIViewController]
        
    private let mainView = DictionaryMainView()

    public init(reactor: DictionaryMainReactor, initialIndex: Int = 0) {
        let vc1 = DictionaryListViewController<DictionaryListTotalReactor>(type: .total)
        vc1.reactor = DictionaryListTotalReactor()
        let vc2 = DictionaryListViewController<DictionaryListMonsterReactor>(type: .monster)
        vc2.reactor = DictionaryListMonsterReactor()
        let vc3 = DictionaryListViewController<DictionaryListItemReactor>(type: .item)
        vc3.reactor = DictionaryListItemReactor()
        let vc4 = DictionaryListViewController<DictionaryListMapReactor>(type: .map)
        vc4.reactor = DictionaryListMapReactor()
        let vc5 = DictionaryListViewController<DictionaryListNpcReactor>(type: .npc)
        vc5.reactor = DictionaryListNpcReactor()
        let vc6 = DictionaryListViewController<DictionaryListQuestReactor>(type: .quest)
        vc6.reactor = DictionaryListQuestReactor()
        viewControllers = [vc1, vc2, vc3, vc4, vc5, vc6]
        
        self.initialIndex = initialIndex
        super.init()
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension DictionaryMainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
        setInitialIndex()
    }
}

// MARK: - SetUp
private extension DictionaryMainViewController {
    func addViews() {
        addChild(mainView.pageViewController)
        mainView.pageViewController.didMove(toParent: self)
        view.addSubview(mainView)
    }
    
    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        mainView.pageViewController.delegate = self
        mainView.pageViewController.dataSource = self
        configureTabCollectionView()
    }
    
    func configureTabCollectionView() {
        mainView.tabCollectionView.collectionViewLayout = createTabLayout()
        mainView.tabCollectionView.delegate = self
        mainView.tabCollectionView.dataSource = self
        mainView.tabCollectionView.register(PageTabbarCell.self, forCellWithReuseIdentifier: PageTabbarCell.identifier)
    }
    
    func createTabLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getPageTabbarLayout() }
            .build()
        layout.register(PageTabbarDividerView.self, forDecorationViewOfKind: PageTabbarDividerView.identifier)
        return layout
    }
    
    func setInitialIndex() {
        let indexPath = IndexPath(item: initialIndex, section: 0)
        
        mainView.pageViewController.setViewControllers(
            [viewControllers[initialIndex]],
            direction: .forward,
            animated: false,
            completion: nil
        )

        mainView.tabCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - Bind
public extension DictionaryMainViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    
    func bindUserActions(reactor: Reactor) {
    }
    
    func bindViewState(reactor: Reactor) {}
}

// MARK: - UIPageViewController DataSource & Delegate
extension DictionaryMainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        return previousIndex >= 0 ? viewControllers[previousIndex] : nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        return nextIndex < viewControllers.count ? viewControllers[nextIndex] : nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first,
           let newIndex = viewControllers.firstIndex(of: visibleViewController)
        {
            currentPageIndex.accept(newIndex)
            mainView.tabCollectionView.selectItem(at: IndexPath(item: newIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            UIView.performWithoutAnimation {
                mainView.tabCollectionView.performBatchUpdates(nil, completion: nil)
            }
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension DictionaryMainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reactor = reactor else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageTabbarCell.identifier, for: indexPath) as? PageTabbarCell else {
            return UICollectionViewCell()
        }
        let title = reactor.currentState.sections[indexPath.row]
        cell.configure(title: title)
        cell.isSelected = indexPath.row == currentPageIndex.value
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newIndex = indexPath.row
        let oldIndex = currentPageIndex.value
        
        guard newIndex != oldIndex else { return }
        
        let direction: UIPageViewController.NavigationDirection = newIndex > oldIndex ? .forward : .reverse
        
        mainView.pageViewController.setViewControllers(
            [viewControllers[newIndex]],
            direction: direction,
            animated: true,
            completion: nil
        )
        
        currentPageIndex.accept(newIndex)
        UIView.performWithoutAnimation {
            mainView.tabCollectionView.performBatchUpdates(nil, completion: nil)
        }
    }
}
