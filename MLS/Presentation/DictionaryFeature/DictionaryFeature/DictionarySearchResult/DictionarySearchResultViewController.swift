import UIKit

import BaseFeature
import DictionaryFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class DictionarySearchResultViewController: BaseViewController, View {
    public typealias Reactor = DictionarySearchResultReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()
    private let initialIndex: Int
    private lazy var currentPageIndex = BehaviorRelay<Int>(value: initialIndex)

    private var viewControllers: [UIViewController]

    private let mainView: DictionaryMainView
    private let underLineController = TabBarUnderlineController()

    public init(
        dictionaryListFactory: DictionaryMainListFactory,
        initialIndex: Int = 0,
        reactor: DictionarySearchResultReactor
    ) {
        let type = reactor.currentState.type
        self.mainView = DictionaryMainView(type: type)
        self.viewControllers = type.pageTabList.map { dictionaryListFactory.make(type: $0, listType: type, keyword: reactor.currentState.keyword) }
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
public extension DictionarySearchResultViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
        setInitialIndex()
    }
}

// MARK: - SetUp
private extension DictionarySearchResultViewController {
    func addViews() {
        addChild(mainView.pageViewController)
        mainView.pageViewController.didMove(toParent: self)
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        mainView.pageViewController.delegate = self
        mainView.pageViewController.dataSource = self
        configureTabCollectionView()
        isBottomTabbarHidden = true
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
public extension DictionarySearchResultViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.searchBar.backButton.rx.tap
            .map { Reactor.Action.backbuttonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.searchBar.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withLatestFrom(reactor.state.map(\.keyword)) { newText, currentKeyword in
                (newText, currentKeyword)
            }
            .filter { newText, currentKeyword in newText != currentKeyword }
            .map { newText, _ in Reactor.Action.updateKeyword(newText) }
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
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.keyword)
            .compactMap { $0 }
            .take(1)
            .bind(to: mainView.searchBar.textField.rx.text)
            .disposed(by: disposeBag)
        
//        for (index, vc) in viewControllers.enumerated() { // 아이템 개수 바인딩
//            guard let listViewController = vc as? DictionaryListViewController else { continue }
//            listViewController.itemCountRelay.observe(on: MainScheduler.instance)
//                .subscribe(onNext: { [weak self] count in
//                    guard let self = self else { return }
//                    let title = reactor.currentState.sections[index]
//                    if let cell = self.mainView.tabCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PageTabbarCell {
//                        cell.inject(title: "\(title)(\(count))")
//                    }
//                })
//                .disposed(by: disposeBag)
//        }
        
        rx.viewWillAppear
            .map {_ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.counts)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.mainView.tabCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UIPageViewController DataSource & Delegate
extension DictionarySearchResultViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
extension DictionarySearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        let count = reactor.currentState.counts[indexPath.row] ?? 0
        cell.inject(title: "\(title)\(count)")
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
