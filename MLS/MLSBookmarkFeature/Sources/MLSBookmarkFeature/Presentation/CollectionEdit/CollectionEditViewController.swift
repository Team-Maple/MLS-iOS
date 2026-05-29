import MLSBookmarkFeatureInterface
import MLSCore
import MLSDesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

final class CollectionEditViewController: BaseViewController, View {
    typealias Reactor = CollectionEditReactor

    var disposeBag = DisposeBag()
    private let bookmarkModalFactory: BookmarkModalFactory
    private var mainView = CollectionEditView()

    init(bookmarkModalFactory: BookmarkModalFactory) {
        self.bookmarkModalFactory = bookmarkModalFactory
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        configureUI()
    }
}

private extension CollectionEditViewController {
    func configureUI() {
        mainView.listCollectionView.collectionViewLayout = createListLayout()
        mainView.listCollectionView.delegate = self
        mainView.listCollectionView.dataSource = self
        mainView.listCollectionView.register(DictionaryListCell.self, forCellWithReuseIdentifier: DictionaryListCell.identifier)
    }

    func createListLayout() -> UICollectionViewLayout {
        CompositionalLayoutBuilder()
            .section { _ in LayoutFactory.getCollectionListEditLayout() }
            .build()
    }
}

extension CollectionEditViewController {
    func bind(reactor: Reactor) {
        mainView.cancelButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.addButtton.rx.tap
            .map { Reactor.Action.addCollectionButtonTapped }
            .bind(to: reactor.action)
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
                case .collectionList:
                    let vc = owner.bookmarkModalFactory.make(
                        bookmarkIds: reactor.currentState.selectedItems.map { $0.bookmarkId }
                    ) { isSave in
                        if isSave {
                            owner.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    owner.present(vc, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

extension CollectionEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reactor?.currentState.bookmarks.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictionaryListCell.identifier, for: indexPath) as? DictionaryListCell,
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.itemTapped(indexPath.row))
    }
}
