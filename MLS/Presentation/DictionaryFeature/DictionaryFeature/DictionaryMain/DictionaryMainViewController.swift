import UIKit

import BaseFeature
import DesignSystem

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public class DictionaryMainReactor: Reactor {
    // MARK: - Reactor
    public enum Action {}
        
    public enum Mutation {}
        
    public struct State {}
        
    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()
        
    // MARK: - init
    public init() {
        self.initialState = State()
    }
        
    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {}
    }
        
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
            
        switch mutation {}
            
        return newState
    }
}

public final class DictionaryMainViewController: BaseViewController, View {
    public typealias Reactor = DictionaryMainReactor
    
    // MARK: - Type
    enum Constant {
        static let pageTabSpacing: CGFloat = 20
        static let pageTabHeight: CGFloat = 40
        static let pageTabWidth: CGFloat = 50
    }
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    private let initialIndex: Int
    private lazy var currentPageIndex = BehaviorRelay<Int>(value: initialIndex)
    
    private let tabItems = ["1", "2", "3", "4", "5"]
    private lazy var viewControllers: [UIViewController] = [
        createTestViewController(title: "페이지 1"),
        createTestViewController(title: "페이지 2"),
        createTestViewController(title: "페이지 3"),
        createTestViewController(title: "페이지 4"),
        createTestViewController(title: "페이지 5")
    ]
    
    // MARK: - Components
    private lazy var tabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Constant.pageTabSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PageTabCell.self, forCellWithReuseIdentifier: PageTabCell.identifier)
        return collectionView
    }()
    
    private let divider = DividerView()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageViewController
    }()
    
    public init(reactor: DictionaryMainReactor, initialIndex: Int = 0) {
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
        view.addSubview(tabCollectionView)
        view.addSubview(divider)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    func setupConstraints() {
        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constant.pageTabHeight)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(tabCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    func createTestViewController(title: String) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemGray6
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return viewController
    }
    
    func setInitialIndex() {
        let indexPath = IndexPath(item: initialIndex, section: 0)
        
        pageViewController.setViewControllers(
            [viewControllers[initialIndex]],
            direction: .forward,
            animated: false,
            completion: nil
        )

        tabCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - Bind
public extension DictionaryMainViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    
    func bindUserActions(reactor: Reactor) {
        Observable.just(tabItems)
            .bind(to: tabCollectionView.rx.items(cellIdentifier: PageTabCell.identifier, cellType: PageTabCell.self)) { index, item, cell in
                cell.inject(input: item)
                cell.isSelected = index == self.currentPageIndex.value
            }
            .disposed(by: disposeBag)
        
        tabCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let newIndex = indexPath.row
                let oldIndex = self.currentPageIndex.value

                guard newIndex != oldIndex else { return }

                let direction: UIPageViewController.NavigationDirection = newIndex > oldIndex ? .forward : .reverse

                self.pageViewController.setViewControllers(
                    [self.viewControllers[newIndex]],
                    direction: direction,
                    animated: true,
                    completion: nil
                )

                self.currentPageIndex.accept(newIndex)
                self.tabCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewState(reactor: Reactor) {}
}

// MARK: - Delegate
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
            tabCollectionView.selectItem(at: IndexPath(item: newIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.pageTabWidth, height: Constant.pageTabHeight)
    }
}
