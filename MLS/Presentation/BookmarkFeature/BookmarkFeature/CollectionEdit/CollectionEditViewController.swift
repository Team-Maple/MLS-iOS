import UIKit

import BaseFeature
import BookmarkFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class CollectionEditViewController: BaseViewController, View {
    public typealias Reactor = CollectionEditReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let bookmarkModalFactory: BookmarkModalFactory

    // MARK: - Components
    private var mainView = CollectionEditView()

    public init(bookmarkModalFactory: BookmarkModalFactory) {
        self.bookmarkModalFactory = bookmarkModalFactory
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
private extension CollectionEditViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
            .section { _ in layoutFactory.getCollectionListEditLayout() }
            .build()
        return layout
    }
}

// MARK: - Bind
extension CollectionEditViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.cancelButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.addButtton.rx.tap
            .map { Reactor.Action.addCollectionButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { _, route in
                switch route {
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.bookmarks)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, _ in
                owner.mainView.listCollectionView.reloadData()
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.selectedItems)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, _ in
                owner.mainView.listCollectionView.reloadData()
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .collcectionList:
                    let viewController = owner.bookmarkModalFactory.make(bookmarkIds: reactor.currentState.selectedItems.map { $0.bookmarkId }) { isSave in
                        if isSave {
                            owner.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    owner.present(viewController, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension CollectionEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reactor?.currentState.bookmarks.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DictionaryListCell.identifier,
                for: indexPath
            ) as? DictionaryListCell,
            let item = reactor?.currentState.bookmarks[indexPath.row]
        else {
            return UICollectionViewCell()
        }
        let isSelected = reactor?.currentState.selectedItems.contains(where: { $0.originalId == item.originalId }) ?? false
        var subText: String? {
            [.item, .monster, .quest].contains(item.type) ? item.level.map { "Lv. \($0)" } : nil
        }

        cell.inject(
            type: .checkbox,
            input: DictionaryListCell.Input(
                type: item.type,
                mainText: item.name,
                subText: subText,
                imageUrl: item.imageUrl ?? "",
                isBookmarked: isSelected
            ),
            indexPath: indexPath,
            collectionView: collectionView,
            onBookmarkTapped: { [weak self] in
                self?.reactor?.action.onNext(.itemTapped(indexPath.row))
            }
        )
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.itemTapped(indexPath.row))
    }
}
