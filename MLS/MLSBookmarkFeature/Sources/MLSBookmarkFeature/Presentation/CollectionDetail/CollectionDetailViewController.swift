import MLSBookmarkFeatureInterface
import MLSCore
import MLSDesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

final class CollectionDetailViewController: BaseViewController, View {
    typealias Reactor = CollectionDetailReactor

    var disposeBag = DisposeBag()

    private let bookmarkModalFactory: BookmarkModalFactory
    private let collectionSettingFactory: CollectionSettingFactory
    private let addCollectionFactory: AddCollectionFactory
    private let collectionEditFactory: CollectionEditFactory
    private let dictionaryDetailFactory: DictionaryDetailFactory

    private var mainView: CollectionDetailView

    init(
        reactor: CollectionDetailReactor,
        bookmarkModalFactory: BookmarkModalFactory,
        collectionSettingFactory: CollectionSettingFactory,
        addCollectionFactory: AddCollectionFactory,
        collectionEditFactory: CollectionEditFactory,
        dictionaryDetailFactory: DictionaryDetailFactory
    ) {
        self.mainView = CollectionDetailView(navTitle: reactor.currentState.collection.name)
        self.bookmarkModalFactory = bookmarkModalFactory
        self.collectionSettingFactory = collectionSettingFactory
        self.addCollectionFactory = addCollectionFactory
        self.collectionEditFactory = collectionEditFactory
        self.dictionaryDetailFactory = dictionaryDetailFactory
        super.init()
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        configureUI()
    }
}

private extension CollectionDetailViewController {
    func configureUI() {
        mainView.listCollectionView.collectionViewLayout = createListLayout()
        mainView.listCollectionView.delegate = self
        mainView.listCollectionView.dataSource = self
        mainView.listCollectionView.register(DictionaryListCell.self, forCellWithReuseIdentifier: DictionaryListCell.identifier)
    }

    func createListLayout() -> UICollectionViewLayout {
        let layout = CompositionalLayoutBuilder()
            .section { _ in LayoutFactory.getDictionaryListLayout() }
            .build()
        layout.register(Neutral300DividerView.self, forDecorationViewOfKind: Neutral300DividerView.identifier)
        return layout
    }
}

extension CollectionDetailViewController {
    func bind(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.emptyView.bookmarkButton.rx.tap
            .map { Reactor.Action.bookmarkButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.navigation.leftButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.navigation.editButton.rx.tap
            .map { Reactor.Action.editButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.navigation.addButton.rx.tap
            .map { Reactor.Action.addButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.collection.recentBookmarks)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, items in
                owner.mainView.listCollectionView.reloadData()
                owner.mainView.isEmptyData(isEmpty: items.isEmpty)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.collection.name)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, name in
                owner.mainView.setName(name: name)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$collectionMenu)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, menu in
                switch menu {
                case .editBookmark:
                    let vc = owner.collectionEditFactory.make(bookmarks: reactor.currentState.collection.recentBookmarks)
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .editName:
                    let vc = owner.addCollectionFactory.make(collection: reactor.currentState.collection)
                    guard let vc = vc as? AddCollectionViewController else { return }
                    vc.dismissed
                        .subscribe { name in
                            reactor.action.onNext(.changeName(name))
                        }
                        .disposed(by: owner.disposeBag)
                    owner.present(vc, animated: true)
                case .delete:
                    GuideAlertFactory.show(
                        mainText: "컬렉션을 삭제하시겠어요?",
                        ctaText: "삭제하기",
                        cancelText: "취소",
                        ctaAction: { reactor.action.onNext(.deleteCollection) },
                        cancelAction: {}
                    )
                default:
                    break
                }
            })
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
                case .edit:
                    let vc = owner.collectionSettingFactory.make(setEditMenu: { menu in
                        owner.reactor?.action.onNext(.selectSetting(menu))
                    })
                    owner.presentModal(vc)
                case .detail(let type, let id):
                    let vc = owner.dictionaryDetailFactory.make(type: type, id: id, bookmarkRelay: nil, loginRelay: nil)
                    owner.navigationController?.pushViewController(vc, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

extension CollectionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reactor?.currentState.collection.recentBookmarks.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictionaryListCell.identifier, for: indexPath) as? DictionaryListCell,
            let item = reactor?.currentState.collection.recentBookmarks[indexPath.row]
        else {
            return UICollectionViewCell()
        }
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
            onBookmarkTapped: {}
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.dataTapped(indexPath.row))
    }
}
