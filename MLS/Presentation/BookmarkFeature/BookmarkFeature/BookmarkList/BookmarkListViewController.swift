import UIKit

import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface

import ReactorKit
import RxSwift

public final class BookmarkListViewController: BaseViewController, View {
    public typealias Reactor = BookmarkListReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let loginFactory: LoginFactory

    private var selectedSortIndex = 0

    // MARK: - Components
    private var mainView: BookmarkListView

    public init(
        reactor: BookmarkListReactor,
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        loginFactory: LoginFactory
    ) {
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.loginFactory = loginFactory
        self.mainView = BookmarkListView(isFilterHidden: reactor.currentState.type.isBookmarkSortHidden)
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
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getDictionaryListLayout() }
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
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.items)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, items in
                owner.mainView.listCollectionView.reloadData()
                owner.mainView.isUserInteractionEnabled = !items.isEmpty
                owner.mainView.checkEmptyData(isEmpty: items.isEmpty)
                if !items.isEmpty {
                    let type = reactor.currentState.type
                    owner.mainView.updateFilter(sortType: type.bookmarkSortedFilter.first)
                }
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .sort(let type):
                    let viewController = owner.sortedFactory.make(sortedOptions: type.bookmarkSortedFilter, selectedIndex: owner.selectedSortIndex) { index in
                        owner.selectedSortIndex = index
                        let selectedFilter = reactor.currentState.type.bookmarkSortedFilter[index]
                        owner.mainView.selectFilter(selectedType: selectedFilter)
                    }
                    owner.tabBarController?.presentModal(viewController)
                case .filter(let type):
                    switch type {
                    case .item:
                        let viewController = owner.itemFilterFactory.make()
                        owner.present(viewController, animated: true)
                    case .monster:
                        let viewController = owner.monsterFilterFactory.make(startLevel: 1, endLevel: 200) { _, _ in }
                        owner.tabBarController?.presentModal(viewController)
                    default:
                        break
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.items)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, _ in
                let type = reactor.currentState.type
                owner.mainView.updateFilter(sortType: type.bookmarkSortedFilter.first)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isLogin)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, isLogin in
                guard let emptyView = owner.mainView.emptyView as? BookmarkEmptyView else { return }
                emptyView.setLabel(isLogin: isLogin, buttonAction: {
                    if isLogin {
                        owner.tabBarController?.selectedIndex = 0
                    } else {
                        let viewController = owner.loginFactory.make(isReLogin: false)
                        owner.navigationController?.pushViewController(viewController, animated: true)
                    }
                })
            })
            .disposed(by: disposeBag)
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
            onBookmarkTapped: { [weak self] isSelected in
                guard let self = self else { return }

                // 로그인 상태 확인
                guard state.isLogin else {
                    GuideAlertFactory.show(
                        mainText: "북마크를 하려면 로그인이 필요해요.",
                        ctaText: "로그인 하기",
                        cancelText: "취소",
                        ctaAction: {
                            let viewController = self.loginFactory.make(isReLogin: false)
                            self.navigationController?.pushViewController(viewController, animated: true)
                        },
                        cancelAction: nil
                    )
                    return
                }

                self.reactor?.action.onNext(.toggleBookmark(item.originalId, isSelected))

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
        )

        return cell
    }
}
