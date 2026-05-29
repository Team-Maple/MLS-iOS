import MLSBookmarkFeatureInterface
import MLSCore
import MLSDesignSystem
import ReactorKit
import RxSwift
import UIKit

final class CollectionListViewController: BaseViewController, View {
    typealias Reactor = CollectionListReactor

    var disposeBag = DisposeBag()
    private var selectedSortIndex = 0

    private let addCollectionFactory: AddCollectionFactory
    private let detailFactory: CollectionDetailFactory
    private let sortedBottomSheetFactory: SortedBottomSheetFactory

    private var mainView = CollectionListView()

    init(
        addCollectionFactory: AddCollectionFactory,
        detailFactory: CollectionDetailFactory,
        sortedBottomSheetFactory: SortedBottomSheetFactory
    ) {
        self.addCollectionFactory = addCollectionFactory
        self.detailFactory = detailFactory
        self.sortedBottomSheetFactory = sortedBottomSheetFactory
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
    }
}

private extension CollectionListViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        mainView.listCollectionView.collectionViewLayout = createListLayout()
        mainView.listCollectionView.delegate = self
        mainView.listCollectionView.dataSource = self
        mainView.listCollectionView.register(CollectionListCell.self, forCellWithReuseIdentifier: CollectionListCell.identifier)

        addFloatingButton { [weak self] in
            guard let self else { return }
            let viewController = self.addCollectionFactory.make(collection: nil)
            guard let vc = viewController as? AddCollectionViewController else { return }
            vc.dismissed
                .withUnretained(self)
                .subscribe { owner, _ in
                    owner.reactor?.action.onNext(.completeAdding)
                }
                .disposed(by: self.disposeBag)
            self.present(vc, animated: true)
        }
    }

    func createListLayout() -> UICollectionViewLayout {
        CompositionalLayoutBuilder()
            .section { _ in LayoutFactory.getCollectionListLayout() }
            .build()
    }
}

extension CollectionListViewController {
    func bind(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.sortButton.rx.tap
            .map { .sortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case .detail(let collection):
                    let viewController = owner.detailFactory.make(collection: collection, onMoveToMain: {
                        if let tabBarController = owner.tabBarController as? BottomTabBarController {
                            tabBarController.selectTab(index: 0)
                            DictionaryTabRegistry.changeTab(index: 0)
                        }
                    })
                    owner.tabBarController?.navigationController?.pushViewController(viewController, animated: true)
                case .sortFilter:
                    let viewController = owner.sortedBottomSheetFactory.make(
                        sortedOptions: reactor.currentState.sortFilter,
                        selectedIndex: owner.selectedSortIndex
                    ) { index in
                        owner.selectedSortIndex = index
                        let selectedFilter = reactor.currentState.sortFilter[index]
                        reactor.action.onNext(.sortOptionSelected(selectedFilter))
                        owner.mainView.selectSort(selectedType: selectedFilter)
                    }
                    owner.tabBarController?.presentModal(viewController)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.collectionList)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, collectionList in
                owner.mainView.updateView(isEmptyData: collectionList.isEmpty)
                owner.mainView.listCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

extension CollectionListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reactor?.currentState.collectionList.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionListCell.identifier, for: indexPath) as? CollectionListCell,
            let item = reactor?.currentState.collectionList[indexPath.row]
        else {
            return UICollectionViewCell()
        }
        cell.inject(input: CollectionListCell.Input(
            title: item.name,
            count: item.recentBookmarks.count,
            images: item.recentBookmarks.map { $0.imageUrl }
        ))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.itemTapped(indexPath.row))
    }
}
