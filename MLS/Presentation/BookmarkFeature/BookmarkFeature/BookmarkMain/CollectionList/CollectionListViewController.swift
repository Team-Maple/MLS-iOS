import UIKit

import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxSwift

public final class CollectionListViewController: BaseViewController, View {
    public typealias Reactor = CollectionListReactor

    // MARK: - Properties
    private let addCollectionFactory: AddCollectionFactory
    private let detailFactory: CollectionDetailFactory
    
    public var disposeBag = DisposeBag()
    public var onDismissWithMessage: ((BookmarkCollection?) -> Void)?

    // MARK: - Components
    private var mainView = CollectionListView()

    public init(addCollectionFactory: AddCollectionFactory, detailFactory: CollectionDetailFactory) {
        self.addCollectionFactory = addCollectionFactory
        self.detailFactory = detailFactory
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
            guard let self = self else { return }
            let viewController = self.addCollectionFactory.make(collection: nil, onDismissWithMessage: { [weak self] collection in
                self?.onDismissWithMessage?(collection)
            })
            self.present(viewController, animated: true)
        }
    }

    func createListLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getCollectionListLayout() }
            .build()
        return layout
    }
}

// MARK: - Bind
extension CollectionListViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {}

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .detail(let collection):
                    let viewController = owner.detailFactory.make(collection: collection)
                    owner.tabBarController?.navigationController?.pushViewController(viewController, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.collections)
            .withUnretained(self)
            .subscribe { owner, collections in
                owner.mainView.updateView(isEmptyData: collections.isEmpty)
                owner.mainView.listCollectionView.reloadData()
            }
            .disposed(by: disposeBag)

//        reactor.state
//            .map(\.isLogin)
//            .distinctUntilChanged()
//            .withUnretained(self)
//            .bind(onNext: { owner, isLogin in
//                owner.mainView.emptyView.setLabel(isLogin: isLogin, buttonAction: {
//                    if isLogin {
//                        owner.tabBarController?.selectedIndex = 0
//                    } else {
//                        let viewController = owner.loginFactory.make(isReLogin: false)
//                        owner.navigationController?.pushViewController(viewController, animated: true)
//                    }
//                })
//            })
//            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension CollectionListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reactor?.currentState.collections.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionListCell.identifier,
                for: indexPath
            ) as? CollectionListCell,
            let item = reactor?.currentState.collections[indexPath.row]
        else {
            return UICollectionViewCell()
        }
        cell.inject(input: CollectionListCell.Input(title: item.title, count: item.count, images: item.thumbnails))
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.itemTapped(indexPath.row))
    }
}
