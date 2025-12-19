import UIKit

import AuthFeatureInterface
import BaseFeature
import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class DictionaryMainViewController: BaseViewController, View, DictionaryTabControllable {
    public typealias Reactor = DictionaryMainReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let initialIndex: Int

    private let searchFactory: DictionarySearchFactory
    private let notificationFactory: DictionaryNotificationFactory
    private let loginFactory: LoginFactory

    private var viewControllers: [UIViewController]

    private var mainView: DictionaryMainView
    let underLineController = TabBarUnderlineController()

    public init(
        initialIndex: Int = 0,
        dictionaryMainListFactory: DictionaryMainListFactory,
        searchFactory: DictionarySearchFactory,
        notificationFactory: DictionaryNotificationFactory,
        loginFactory: LoginFactory,
        reactor: DictionaryMainReactor
    ) {
        let type = reactor.currentState.type
        self.mainView = DictionaryMainView(type: type)
        self.viewControllers = type.pageTabList.map { dictionaryMainListFactory.make(type: $0, listType: type, keyword: "") }
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
public extension DictionaryMainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
        setInitialIndex()
        DictionaryTabRegistry.register(controller: self)
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

    func moveToTab(oldIndex: Int, newIndex: Int) {
        guard newIndex < viewControllers.count else { return }
        let direction: UIPageViewController.NavigationDirection = newIndex > oldIndex ? .forward : .reverse

        mainView.pageViewController.setViewControllers(
            [viewControllers[newIndex]],
            direction: direction,
            animated: true,
            completion: nil
        )

        mainView.tabCollectionView.selectItem(
            at: IndexPath(item: newIndex, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )

        underLineController.animateIndicatorToSelectedItem()
    }
}

// MARK: - Bind
public extension DictionaryMainViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { .viewWillAppear }
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
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .search:
                    let controller = owner.searchFactory.make()
                    owner.navigationController?.pushViewController(controller, animated: true)
                case .notification:
                    let controller = owner.notificationFactory.make()
                    owner.navigationController?.pushViewController(controller, animated: true)
                case .login:
                    let controller = owner.loginFactory.make(exitRoute: .pop, onLoginCompleted: nil)
                    owner.navigationController?.pushViewController(controller, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.currentPageIndex)
            .distinctUntilChanged()
            .skip(1)
            .withUnretained(self)
            .subscribe(onNext: { owner, newIndex in
                let oldIndex = reactor.currentState.oldPageIndex
                owner.moveToTab(oldIndex: oldIndex, newIndex: newIndex)
            })
            .disposed(by: disposeBag)
    }
}

public extension DictionaryMainViewController {
    func changeTab(index: Int) {
        reactor?.action.onNext(.changeTab(index))
    }
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
           let newIndex = viewControllers.firstIndex(of: visibleViewController) {
            reactor?.action.onNext(.changeTab(newIndex))
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
        cell.inject(title: title)
        cell.isSelected = indexPath.row == reactor.currentState.currentPageIndex
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newIndex = indexPath.row
        guard let oldIndex = reactor?.currentState.currentPageIndex else { return }
        guard newIndex != oldIndex else { return }

        reactor?.action.onNext(.changeTab(newIndex))
    }
}
