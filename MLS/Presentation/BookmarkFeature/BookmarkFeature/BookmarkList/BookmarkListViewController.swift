import UIKit

import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class BookmarkListViewController: BaseViewController, View {
    public typealias Reactor = BookmarkListReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let bookmarkChangeRelay = PublishRelay<(id: Int, newBookmarkId: Int?)>()
    private var undoRelay = PublishRelay<Void>()
    private var addCollectionRelay = PublishRelay<Int>()

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let loginFactory: LoginFactory
    private let dictionaryDetailFactory: DictionaryDetailFactory
    private let collectionEditFactory: CollectionEditFactory

    private var selectedSortIndex = 0

    // MARK: - Components
    private var mainView: BookmarkListView
    private var emptyView = DataEmptyView(type: .bookmark)

    public init(
        reactor: BookmarkListReactor,
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        loginFactory: LoginFactory,
        dictionaryDetailFactory: DictionaryDetailFactory,
        collectionEditFactory: CollectionEditFactory
    ) {
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.loginFactory = loginFactory
        self.dictionaryDetailFactory = dictionaryDetailFactory
        self.collectionEditFactory = collectionEditFactory
        self.mainView = BookmarkListView(isFilterHidden: reactor.currentState.type.isBookmarkSortHidden, bookmarkEmptyView: emptyView)
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
private extension BookmarkListViewController {
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
        mainView.listCollectionView.register(DictionaryListCell.self, forCellWithReuseIdentifier: DictionaryListCell.identifier)
    }

    func createListLayout() -> UICollectionViewLayout {
        guard let isHidden = reactor?.currentState.type.isBookmarkSortHidden else { return UICollectionViewLayout() }
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getDictionaryListLayout(isFilterHidden: isHidden) }
            .build()
        layout.register(Neutral300DividerView.self, forDecorationViewOfKind: Neutral300DividerView.identifier)
        return layout
    }
}

// MARK: - Bind
extension BookmarkListViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.sortButton.rx.tap
            .map { Reactor.Action.sortButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.editButton?.rx.tap
            .map { Reactor.Action.editButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        emptyView.button.rx.tap
            .map { .emptyButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.items)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, items in
                owner.mainView.checkEmptyData(isEmpty: items.isEmpty)
                owner.mainView.listCollectionView.reloadData()
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case .sort(let type):
                    let viewController = owner.sortedFactory.make(sortedOptions: type.bookmarkSortedFilter, selectedIndex: owner.selectedSortIndex) { index in
                        owner.selectedSortIndex = index
                        let selectedFilter = reactor.currentState.type.bookmarkSortedFilter[index]
                        reactor.action.onNext(.sortOptionSelected(selectedFilter))
                        owner.mainView.selectSort(selectedType: selectedFilter)
                    }
                    owner.tabBarController?.presentModal(viewController)
                case .filter(let type):
                    switch type {
                    case .item:
                        let viewController = owner.itemFilterFactory.make { results in
                            reactor.action.onNext(.itemFilterOptionSelected(results))

                            if results.isEmpty {
                                owner.mainView.resetFilter()
                            } else {
                                owner.mainView.selectFilter()
                            }
                        }
                        owner.present(viewController, animated: true)
                    case .monster:
                        let viewController = owner.monsterFilterFactory.make(startLevel: reactor.currentState.startLevel ?? 1, endLevel: reactor.currentState.endLevel ?? 200) { startLevel, endLevel in
                            owner.mainView.selectFilter()
                            reactor.action.onNext(.filterOptionSelected(startLevel: startLevel, endLevel: endLevel))
                        }
                        owner.tabBarController?.presentModal(viewController)
                    default:
                        break
                    }
                case .detail(let type, let id):
                    let viewcontroller = owner.dictionaryDetailFactory.make(type: type, id: id, bookmarkRelay: owner.bookmarkChangeRelay, loginRelay: nil)
                    owner.navigationController?.pushViewController(viewcontroller, animated: true)
                case .login:
                    let viewcontroller = owner.loginFactory.make(exitRoute: .pop)
                    owner.navigationController?.pushViewController(viewcontroller, animated: true)

                case .dictionary:
                    if let tabBarController = owner.tabBarController as? BottomTabBarController {
                        tabBarController.selectTab(index: 0)
                        DictionaryTabRegistry.changeTab(index: reactor.currentState.type.tabIndex)
                    }
                case .edit:
                    let viewController = owner.collectionEditFactory.make(bookmarks: reactor.currentState.items)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .bookmarkError:
                    ToastFactory.createToast(message: "북마크 요청에 실패했어요. 다시 시도해주세요.")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.type)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, type in
                owner.mainView.updateBookmarkFilter(type: type)
                owner.mainView.updateFilter(sortType: type.bookmarkSortedFilter.first)
            })
            .disposed(by: disposeBag)

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

    private func presentAddSnackBar(item: BookmarkResponse) {
        SnackBarFactory.createSnackBar(
            type: .normal,
            imageUrl: item.imageUrl,
            imageBackgroundColor: item.type.backgroundColor,
            text: "아이템을 북마크에 추가했어요.",
            buttonText: "컬렉션 추가",
            buttonAction: { [weak self] in
                self?.reactor?.state.map(\.items)
                    .compactMap { items in
                        items.first(where: { $0.originalId == item.originalId })?.bookmarkId
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

    private func presentDeleteSnackBar(item: BookmarkResponse) {
        SnackBarFactory.createSnackBar(
            type: .delete,
            imageUrl: item.imageUrl,
            imageBackgroundColor: item.type.backgroundColor,
            text: "아이템을 북마크에서 삭제했어요.",
            buttonText: "되돌리기",
            buttonAction: { [weak self] in
                self?.undoRelay.accept(())
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

}

// MARK: - Delegate
extension BookmarkListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reactor?.currentState.items.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let state = reactor?.currentState else { return UICollectionViewCell() }
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DictionaryListCell.identifier,
                for: indexPath
            ) as? DictionaryListCell
        else {
            return UICollectionViewCell()
        }

        let item = state.items[indexPath.row]
        var subText: String? {
            [.item, .monster, .quest].contains(item.type) ? item.level.map { "Lv. \($0)" } : nil
        }
        cell.inject(
            type: .bookmark,
            input: DictionaryListCell.Input(
                type: item.type,
                mainText: item.name,
                subText: subText,
                imageUrl: item.imageUrl ?? "",
                isBookmarked: true
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
                self.reactor?.action.onNext(.toggleBookmark(item.originalId))
            }
        )

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.dataTapped(indexPath.item))
    }
}
