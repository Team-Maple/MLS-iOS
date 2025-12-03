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
        self.mainView = DictionaryListView(
            isFilterHidden: reactor.currentState.type.isSortHidden)
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
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getDictionaryListLayout() }
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
        reactor.state
            .map { $0.totalCounts }
            .distinctUntilChanged()
            .bind(to: itemCountRelay)
            .disposed(by: disposeBag)

        reactor.state.map(\.listItems)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] item in
                self?.mainView.listCollectionView.reloadData()
                self?.mainView.emptyView.isHidden = !item.isEmpty
                self?.mainView.listCollectionView.isHidden = item.isEmpty
                // 보여줄 item이 없을 경우, 터치를 막는데 왜 막는건지?
                // 몬스터나 아이템 탭에서 필터링을 하다가 item이 없을 경우, 필터 버튼도 터치가 안되서 계속 item 없음
                // self?.mainView.isUserInteractionEnabled = !item.isEmpty
            })
            .disposed(by: disposeBag)

        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .sort(let type):
                    let viewController = owner.sortedFactory.make(
                        sortedOptions: type.bookmarkSortedFilter,
                        selectedIndex: owner.selectedSortIndex
                    ) { index in
                        owner.selectedSortIndex = index
                        let selectedFilter = reactor.currentState.type.bookmarkSortedFilter[index]
                        reactor.action.onNext(.sortOptionSelected(selectedFilter))
                        owner.mainView.selectSort(selectedType: selectedFilter)
                        reactor.action.onNext(.fetchListFilter)
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
                        let viewController = owner.monsterFilterFactory.make(startLevel: reactor.currentState.startLevel ?? 0, endLevel: reactor.currentState.endLevel ?? 200) { startLevel, endLevel in
                            owner.mainView.selectFilter()
                            reactor.action.onNext(.filterOptionSelected(startLevel: startLevel, endLevel: endLevel))
                        }
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
            .map(\.type)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, type in
                owner.mainView.updateFilter(sortType: type.sortedFilter.first)
            })
            .disposed(by: disposeBag)
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
            onBookmarkTapped: { [weak self] isSelected in
                guard let self = self else { return }

                guard state.isLogin else {
                    GuideAlertFactory.show(
                        mainText: "북마크를 하려면 로그인이 필요해요.",
                        ctaText: "로그인 하기",
                        cancelText: "취소",
                        ctaAction: {
                            let viewController = self.loginFactory.make(
                                exitRoute: .pop)
                            self.navigationController?.pushViewController(
                                viewController, animated: true
                            )
                        },
                        cancelAction: nil
                    )
                    return
                }

                if item.bookmarkId != nil {
                    self.reactor?.action.onNext(
                        .toggleBookmark(item.id, isSelected))
                    SnackBarFactory.createSnackBar(
                        type: .delete,
                        imageUrl: item.imageUrl,
                        imageBackgroundColor: item.type.backgroundColor,
                        text: "아이템을 북마크에서 삭제했어요.",
                        buttonText: "되돌리기",
                        buttonAction: { [weak self] in
                            self?.reactor?.action.onNext(
                                .undoLastDeletedBookmark)
                        }
                    )
                } else {
                    self.reactor?.action.onNext(
                        .toggleBookmark(item.id, isSelected))
                    SnackBarFactory.createSnackBar(
                        type: .normal,
                        imageUrl: item.imageUrl,
                        imageBackgroundColor: item.type.backgroundColor,
                        text: "아이템을 북마크에 추가했어요.",
                        buttonText: "컬렉션 추가",
                        buttonAction: {
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self,
                                      let id = item.bookmarkId else { return }

                                let viewController = self.bookmarkModalFactory.make(bookmarkIds: [id], onComplete: { isAdd in
                                    if isAdd {
                                        ToastFactory.createToast(
                                            message:
                                            "컬렉션에 추가되었어요. 북마크 탭에서 확인 할 수 있어요."
                                        )
                                    }
                                })

                                viewController.modalPresentationStyle = .pageSheet
                                if let sheet = viewController.sheetPresentationController {
                                    sheet.detents = [.medium(), .large()]
                                    sheet.prefersGrabberVisible = true
                                    sheet.preferredCornerRadius = 16
                                }
                                self.present(viewController, animated: true)
                            }
                        }
                    )
                }
            }
        )

        return cell
    }

    public func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
    ) {
        guard let reactor = reactor else { return }
        let item: DictionaryMainItemResponse

        item = reactor.currentState.listItems[indexPath.item]
        let viewController: UIViewController

        switch reactor.currentState.type {
        case .total:
            guard let type = item.type.toDictionaryType else { return }
            viewController = detailFactory.make(type: type, id: item.id)
        default:
            // 단일 타입일 경우 리액터 타입에 따라 처리
            viewController = detailFactory.make(
                type: reactor.currentState.type, id: item.id
            )
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            reactor?.action.onNext(.setCurrentPage) // 페이지 올리고
            reactor?.action.onNext(.fetchList) // 해당 페이지로 데이터 불러오기
        }
    }
}
