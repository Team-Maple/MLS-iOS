import UIKit

import BaseFeature
import BookmarkFeatureInterface
import DesignSystem
import DomainInterface

import ReactorKit
import RxSwift
import SnapKit

public final class BookmarkModalViewController: BaseViewController, View {
    public typealias Reactor = BookmarkModalReactor

    // MARK: - Properties
    private let addCollectionFactory: AddCollectionFactory
    
    public var onDismissWithMessage: ((BookmarkCollection?) -> Void)?
    public var onDismissWithCollections: (([BookmarkCollection?]) -> Void)?
    
    public var disposeBag = DisposeBag()

    // MARK: - Components
    private let mainView = BookmarkModalView()

    // MARK: - Init
    public init(addCollectionFactory: AddCollectionFactory) {
        self.addCollectionFactory = addCollectionFactory
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - Setup
private extension BookmarkModalViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        mainView.folderCollectionView.collectionViewLayout = createListLayout()
        mainView.folderCollectionView.delegate = self
        mainView.folderCollectionView.dataSource = self

        mainView.folderCollectionView.register(AddFolderCell.self, forCellWithReuseIdentifier: AddFolderCell.identifier)
        mainView.folderCollectionView.register(FolderCell.self, forCellWithReuseIdentifier: FolderCell.identifier)
    }

    func createListLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()
        return CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getCollectionModalLayout() }
            .build()
    }
}

// MARK: - Bind
extension BookmarkModalViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {
        mainView.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.collections)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, items in
                owner.mainView.setButtonTitle(count: items.count)
                owner.mainView.folderCollectionView.reloadData()
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe(onNext: { owner, route in
                switch route {
                case .dismiss:
                    owner.dismiss(animated: true)
                case .addCollection:
                    let viewController = owner.addCollectionFactory.make(collection: nil, onDismissWithMessage: { [weak self] collection in
                        self?.onDismissWithMessage?(collection)
                    })
                    owner.present(viewController, animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionView Delegate
extension BookmarkModalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (reactor?.currentState.collections.count ?? 0) + 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: AddFolderCell.identifier, for: indexPath) as? AddFolderCell ?? UICollectionViewCell()
        } else {
            guard let reactor = reactor else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.identifier, for: indexPath) as? FolderCell else {
                return UICollectionViewCell()
            }
            let title = reactor.currentState.collections[indexPath.row - 1].title
            cell.inject(title: title)
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            reactor?.action.onNext(.addCollectionTapped)
        } else {
            reactor?.action.onNext(.selectItem(indexPath.row))
            guard let cell = collectionView.cellForItem(at: indexPath) as? FolderCell else { return }
            cell.checkBoxButton.isSelected.toggle()
        }
    }
}
