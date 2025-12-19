import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

public final class DictionaryListViewController: BaseViewController, View {
    public typealias Reactor = DictionaryListReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let detailFactory: DictionaryDetailFactory
    private let loginFactory: LoginFactory

    private var selectedSortIndex = 0
    public let itemCountRelay = PublishRelay<Int>()
    private let bookmarkChangeRelay = PublishRelay<(id: Int, newBookmarkId: Int?)>()
    private var loginRelay = PublishRelay<Void>()
    private var lastPagingTime: Date = .distantPast

    // MARK: - Components
    private var mainView: DictionaryListView

    public init(
        reactor: DictionaryListReactor,
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        detailFactory: DictionaryDetailFactory, loginFactory: LoginFactory
    ) {
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.detailFactory = detailFactory
        self.loginFactory = loginFactory
        self.mainView = DictionaryListView(isFilterHidden: reactor.currentState.type.isSortHidden)
        super.init()
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension DictionaryListViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        mainView.listCollectionView.collectionViewLayout = createListLayout()
        mainView.listCollectionView.delegate = self
        mainView.listCollectionView.dataSource = self
        mainView.listCollectionView.register(
            DictionaryListCell.self,
            forCellWithReuseIdentifier: DictionaryListCell.identifier
        )
    }

    func createListLayout() -> UICollectionViewLayout {
        guard let isHidden = reactor?.currentState.type.isSortHidden else { return UICollectionViewLayout() }
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getDictionaryListLayout(isFilterHidden: isHidden) }
            .build()
        layout.register(
            Neutral300DividerView.self,
            forDecorationViewOfKind: Neutral300DividerView.identifier
        )
        return layout
    }
}

// MARK: - Bind
extension DictionaryListViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.sortButton.rx.tap
            .map { Reactor.Action.sortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        bindItemCount(reactor: reactor)
        bindLifecycle(reactor: reactor)
        bindRoute(reactor: reactor)
        bindTypeChanges(reactor: reactor)
        bindBookmarkChange()
        bindListItems()
        bindUIEvents(reactor: reactor)
    }

    // MARK: - Sub-binds

    private func bindItemCount(reactor: Reactor) {
        reactor.state
            .map { $0.totalCounts }
            .distinctUntilChanged()
            .bind(to: itemCountRelay)
            .disposed(by: disposeBag)
    }

    private func bindLifecycle(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindRoute(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, route in
                switch route {
                case .sort(let type):
                    let viewController = owner.sortedFactory.make(
                        sortedOptions: type.bookmarkSortedFilter,
                        selectedIndex: owner.selectedSortIndex
                    ) { [weak self, weak reactor] index in
                        guard let self, let reactor else { return }
                        self.selectedSortIndex = index
                        let selectedFilter = reactor.currentState.type.bookmarkSortedFilter[index]
                        reactor.action.onNext(.sortOptionSelected(selectedFilter))
                        self.mainView.selectSort(selectedType: selectedFilter)
                    }
                    owner.tabBarController?.presentModal(viewController)
                case .filter(let type):
                    switch type {
                    case .item:
                        let viewController = owner.itemFilterFactory.make { [weak self, weak reactor] results in
                            guard let self, let reactor else { return }
                            reactor.action.onNext(.itemFilterOptionSelected(results))

                            if results.isEmpty {
                                self.mainView.resetFilter()
                            } else {
                                self.mainView.selectFilter()
                            }
                        }
                        owner.present(viewController, animated: true)
                    case .monster:
                        let viewController = owner.monsterFilterFactory.make(
                            startLevel: reactor.currentState.startLevel ?? 0,
                            endLevel: reactor.currentState.endLevel ?? 200
                        ) { [weak self, weak reactor] startLevel, endLevel in
                            self?.mainView.selectFilter()
                            reactor?.action.onNext(.filterOptionSelected(startLevel: startLevel, endLevel: endLevel))
                        }
                        owner.tabBarController?.presentModal(viewController)
                    default:
                        break
                    }
                case .bookmarkError:
                    ToastFactory.createToast(message: "북마크 요청에 실패했어요. 다시 시도해주세요.")
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindTypeChanges(reactor: Reactor) {
        reactor.state
            .map(\.type)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, type in
                owner.mainView.updateFilter(sortType: type.sortedFilter.first)
            })
            .disposed(by: disposeBag)
    }

    private func bindBookmarkChange() {
        bookmarkChangeRelay
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, bookmarkResult in
                let (id, newBookmarkId) = bookmarkResult
                owner.reactor?.action.onNext(.updateBookmark(id: id, newBookmarkId: newBookmarkId))
            })
            .disposed(by: disposeBag)
    }

    private func bindListItems() {
        reactor?.state.map(\.listItems)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { owner, items in
                owner.updateCollectionView(items: items)
            }
            .disposed(by: disposeBag)
    }

    private func bindUIEvents(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$uiEvent) }
            .withUnretained(self)
            .subscribe(onNext: { owner, event in
                switch event {
                case .add(let item):
                    owner.presentAddSnackBar(item: item)
                case .delete(let item):
                    owner.presentDeleteSnackBar(item: item)
                case .login:
                    owner.presentLoginGuide()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func presentAddSnackBar(item: DictionaryMainItemResponse) {
        SnackBarFactory.createSnackBar(
            type: .normal,
            imageUrl: item.imageUrl,
            imageBackgroundColor: item.type.backgroundColor,
            text: "아이템을 북마크에 추가했어요.",
            buttonText: "컬렉션 추가",
            buttonAction: { [weak self] in
                self?.reactor?.state.map(\.listItems)
                    .compactMap { list in
                        list.first(where: { $0.id == item.id })?.bookmarkId
                    }
                    .take(1)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] bookmarkId in
                        guard let self else { return }
                        let vc = self.bookmarkModalFactory.make(bookmarkIds: [bookmarkId]) { isAdd in
                            if isAdd {
                                ToastFactory.createToast(
                                    message: "컬렉션에 추가되었어요. 북마크 탭에서 확인 할 수 있어요."
                                )
                            }
                        }
                        vc.modalPresentationStyle = .pageSheet
                        if let sheet = vc.sheetPresentationController {
                            sheet.detents = [.medium(), .large()]
                            sheet.prefersGrabberVisible = true
                            sheet.preferredCornerRadius = 16
                        }
                        self.present(vc, animated: true)
                    })
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            }
        )
    }

    private func presentDeleteSnackBar(item: DictionaryMainItemResponse) {
        SnackBarFactory.createSnackBar(
            type: .delete,
            imageUrl: item.imageUrl,
            imageBackgroundColor: item.type.backgroundColor,
            text: "아이템을 북마크에서 삭제했어요.",
            buttonText: "되돌리기",
            buttonAction: { [weak self] in
                self?.reactor?.action.onNext(.undoLastDeletedBookmark)
            }
        )
    }

    private func presentLoginGuide() {
        GuideAlertFactory.show(
            mainText: "북마크를 하려면 로그인이 필요해요.",
            ctaText: "로그인 하기",
            cancelText: "취소",
            ctaAction: { [weak self] in
                guard let self else { return }
                let vc = self.loginFactory.make(exitRoute: .pop)
                self.navigationController?.pushViewController(vc, animated: true)
            },
            cancelAction: nil
        )
    }

    private func updateCollectionView(items: [DictionaryMainItemResponse]) {
        let collectionView = mainView.listCollectionView
        mainView.checkEmptyData(isEmpty: items.isEmpty)

        guard let reactor = reactor else { return }
        if reactor.currentState.currentPage == 0, !reactor.currentState.isBookmarkUpdateOnly {
            collectionView.reloadData()
        } else {
            let startIndex = collectionView.numberOfItems(inSection: 0)
            let endIndex = items.count
            if endIndex > startIndex {
                let indexPaths = (startIndex ..< endIndex).map { IndexPath(item: $0, section: 0) }
                collectionView.performBatchUpdates {
                    collectionView.insertItems(at: indexPaths)
                }
            }

            for cell in collectionView.visibleCells {
                if let indexPath = collectionView.indexPath(for: cell),
                   indexPath.item < items.count,
                   let cell = cell as? DictionaryListCell {
                    let item = items[indexPath.item]
                    cell.updateBookmarkState(isBookmarked: item.bookmarkId != nil)
                }
            }
        }
    }
}

// MARK: - Delegate
extension DictionaryListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let state = reactor?.currentState else { return 0 }
        return state.listItems.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let state = reactor?.currentState,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictionaryListCell.identifier, for: indexPath) as? DictionaryListCell else { return UICollectionViewCell() }
        let item = state.listItems[indexPath.row]
        let subText: String? = [.item, .monster, .quest].contains(item.type) ? item.level.map { "Lv. \($0)" } : nil

        cell.inject(
            type: .bookmark,
            input: DictionaryListCell.Input(
                type: item.type,
                mainText: item.name,
                subText: subText,
                imageUrl: item.imageUrl ?? "",
                isBookmarked: item.bookmarkId != nil
            ),
            indexPath: indexPath,
            collectionView: collectionView,
            isMap: item.type == .map,
            onBookmarkTapped: { [weak self] in
                guard let self else { return }
                guard state.isLogin else {
                    self.reactor?.action.onNext(.showLogin)
                    return
                }
                self.reactor?.action.onNext(.toggleBookmark(id: item.id))
            }
        )

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let reactor = reactor else { return }
        let item: DictionaryMainItemResponse

        item = reactor.currentState.listItems[indexPath.item]
        let viewController: UIViewController

        switch reactor.currentState.type {
        case .total:
            guard let type = item.type.toDictionaryType else { return }
            viewController = detailFactory.make(type: type, id: item.id, bookmarkRelay: bookmarkChangeRelay, loginRelay: loginRelay)
        default:
            // 단일 타입일 경우 리액터 타입에 따라 처리
            viewController = detailFactory.make(
                type: reactor.currentState.type, id: item.id, bookmarkRelay: bookmarkChangeRelay, loginRelay: loginRelay
            )
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let now = Date()
        guard now.timeIntervalSince(lastPagingTime) > 0.5 else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            lastPagingTime = now
            reactor?.action.onNext(.setCurrentPage)
            reactor?.action.onNext(.fetchList)
        }
    }
}
