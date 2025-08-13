import UIKit

import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class DictionaryListViewController: BaseViewController, View {
    public typealias Reactor = DictionaryListReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let detailFactory: DictionaryDetailFactory

    // MARK: - Components
    private var mainView: DictionaryListView

    public init(reactor: DictionaryListReactor, itemFilterFactory: ItemFilterBottomSheetFactory, monsterFilterFactory: MonsterFilterBottomSheetFactory, sortedFactory: SortedBottomSheetFactory, bookmarkModalFactory: BookmarkModalFactory, dictionaryDetailFactory: DictionaryDetailFactory) {
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.detailFactory = dictionaryDetailFactory
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
            .map { Reactor.Action.filterbButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.items)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] item in
                self?.mainView.listCollectionView.reloadData()
                self?.mainView.emptyView.isHidden = !item.isEmpty
                self?.mainView.listCollectionView.isHidden = item.isEmpty
                self?.mainView.isUserInteractionEnabled = !item.isEmpty
            })
            .disposed(by: disposeBag)

        rx.viewWillAppear
            .take(1)
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
                    let viewController = owner.sortedFactory.make(sortedOptions: type.sortedFilter, selectedIndex: 0) { index in
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
                        let viewController = owner.monsterFilterFactory.make()
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
        reactor?.currentState.items.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DictionaryListCell.identifier,
                for: indexPath
            ) as? DictionaryListCell,
            let item = reactor?.currentState.items[indexPath.row]
        else {
            return UICollectionViewCell()
        }

        cell.inject(type: .bookmark,
                    input: DictionaryListCell.Input(
                        type: item.type,
                        mainText: item.mainText,
                        subText: item.subText,
                        image: item.image,
                        isBookmarked: item.isBookmarked
                    ),
                    onBookmarkTapped: { [weak self] in
                        guard let self = self else { return }
                        if item.isBookmarked {
                            self.reactor?.action.onNext(.toggleBookmark(item.id))
                            SnackBarFactory.createSnackBar(type: .delete, image: item.image, imageBackgroundColor: item.type.backgroundColor, text: "아이템을 북마크에서 삭제했어요.", buttonText: "되돌리기", buttonAction: { [weak self] in
                                self?.reactor?.action.onNext(.toggleBookmark(item.id))
                            })
                        } else {
                            // 로그인 여부 확인
                            if false {
                                GuideAlertFactory.show(
                                    mainText: "북마크를 하려면 로그인이 필요해요.",
                                    ctaText: "로그인 하기",
                                    cancelText: "취소",
                                    ctaAction: {
                                        print("로그인 화면으로 이동")
                                    },
                                    cancelAction: {
                                        print("취소됨")
                                    }
                                )
                            } else {
                                self.reactor?.action.onNext(.toggleBookmark(item.id))
                                SnackBarFactory.createSnackBar(type: .normal, image: item.image, imageBackgroundColor: item.type.backgroundColor, text: "아이템을 북마크에 추가했어요.", buttonText: "컬렉션 추가", buttonAction: {
                                    DispatchQueue.main.async {
                                        let viewController = self.bookmarkModalFactory.make(onDismissWithColletions: { _ in }, onDismissWithMessage: { _ in
                                            ToastFactory.createToast(message: "컬렉션에 추가되었어요. 북마크 탭에서 확인 할 수 있어요.")
                                        })

                                        viewController.modalPresentationStyle = .pageSheet

                                        if let sheet = viewController.sheetPresentationController {
                                            sheet.detents = [.medium(), .large()]
                                            sheet.prefersGrabberVisible = true
                                            sheet.preferredCornerRadius = 16
                                        }

                                        self.present(viewController, animated: true)
                                    }
                                })
                            }
                        }
                    })

        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = detailFactory.make()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
