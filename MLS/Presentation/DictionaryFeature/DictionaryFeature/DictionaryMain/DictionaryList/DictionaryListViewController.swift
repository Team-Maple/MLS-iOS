import UIKit

import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxSwift

public final class DictionaryListViewController: BaseViewController, View {
    public typealias Reactor = DictionaryListReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()
    var type: DictionaryType

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let sortedFactory: SortedBottomSheetFactory

    // MARK: - Components
    private let mainView: DictionaryListView

    public init(type: DictionaryType, itemFilterFactory: ItemFilterBottomSheetFactory, monsterFilterFactory: MonsterFilterBottomSheetFactory, sortedFactory: SortedBottomSheetFactory) {
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.type = type
        self.mainView = DictionaryListView(isFilterHidden: type.isFilterHidden)
        super.init()
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
            .section { _ in layoutFactory.getPageListLayout() }
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
                    let viewController = owner.sortedFactory.make(sortedOptions: type.sortedFilter, selectedIndex: 0)
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

        cell.inject(
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
                } else {
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
                }
            }
        )

        return cell
    }
}
