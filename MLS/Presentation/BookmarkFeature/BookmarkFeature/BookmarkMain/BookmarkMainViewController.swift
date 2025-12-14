import UIKit

import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class BookmarkMainViewController: BaseViewController, View {
    public typealias Reactor = BookmarkMainReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let initialIndex: Int
    private lazy var currentPageIndex = BehaviorRelay<Int>(value: initialIndex)

    private var onBoardingFactory: BookmarkOnBoardingFactory
    private let searchFactory: DictionarySearchFactory
    private let notificationFactory: DictionaryNotificationFactory
    private let loginFactory: LoginFactory

    private var viewControllers: [UIViewController]

    private let mainView: BookmarkMainView
    private let underLineController = TabBarUnderlineController()

    public init(
        initialIndex: Int = 0,
        onBoardingFactory: BookmarkOnBoardingFactory,
        bookmarkListFactory: BookmarkListFactory,
        collectionListFactory: CollectionListFactory,
        searchFactory: DictionarySearchFactory,
        notificationFactory: DictionaryNotificationFactory,
        loginFactory: LoginFactory,
        reactor: BookmarkMainReactor
    ) {
        let type = reactor.currentState.type
        self.mainView = BookmarkMainView(type: type)
        self.viewControllers = type.pageTabList.enumerated().map { index, tabType in
            if index == 1 {
                return collectionListFactory.make()
            } else {
                return bookmarkListFactory.make(type: tabType, listType: type)
            }
        }
        self.onBoardingFactory = onBoardingFactory
        self.searchFactory = searchFactory
        self.notificationFactory = notificationFactory
        self.loginFactory = loginFactory
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
public extension BookmarkMainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
        setInitialIndex()
    }
}

// MARK: - SetUp
private extension BookmarkMainViewController {
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
        underLineController.configure(with: mainView.tabCollectionView)
    }

    func createTabLayout() -> UICollectionViewLayout {
        let layout = CompositionalLayoutBuilder()
            .section { _ in LayoutFactory.getPageTabbarLayout(underLineController: underLineController) }
            .build()
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
        DispatchQueue.main.async { [weak self] in
            self?.underLineController.setInitialIndicator()
        }
    }
}

// MARK: - Bind
public extension BookmarkMainViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.headerView.firstIconButton.rx.tap
            .map { Reactor.Action.searchButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.headerView.secondIconButton.rx.tap
            .map { Reactor.Action.notificationButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.emptyView.button.rx.tap
            .map { Reactor.Action.loginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .search:
                    let controller = owner.searchFactory.make()
                    owner.navigationController?.pushViewController(controller, animated: true)
                case .notification:
                    let controller = owner.notificationFactory.make()
                    owner.navigationController?.pushViewController(controller, animated: true)
                case .onBoarding:
                    let viewController = owner.onBoardingFactory.make()
                    viewController.modalPresentationStyle = .fullScreen
                    owner.present(viewController, animated: true)
                case .login:
                    let controller = owner.loginFactory.make(exitRoute: .pop, onLoginCompleted: nil)
                    owner.navigationController?.pushViewController(controller, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isLogin }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { owner, isLogin in
                owner.mainView.updateLoginState(isLogin: isLogin)
                owner.underLineController.setHidden(hidden: !isLogin)
            }
            .disposed(by: disposeBag)

    }
}

// MARK: - UIPageViewController DataSource & Delegate
extension BookmarkMainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
           let newIndex = viewControllers.firstIndex(of: visibleViewController) {
            currentPageIndex.accept(newIndex)
            mainView.tabCollectionView.selectItem(at: IndexPath(item: newIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            underLineController.animateIndicatorToSelectedItem()
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension BookmarkMainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        cell.inject(title: title)
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
        underLineController.animateIndicatorToSelectedItem()
    }
}
