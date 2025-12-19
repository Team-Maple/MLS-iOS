import UIKit

import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class BookmarkModalViewController: BaseViewController, View {
    public typealias Reactor = BookmarkModalReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()
    public var onCompleted: ((Bool) -> Void)?

    private let addCollectionFactory: AddCollectionFactory

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
        rx.viewWillAppear
            .map { .viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.addButtton.rx.tap
            .map { Reactor.Action.addButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.collections)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.mainView.folderCollectionView.reloadData()
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.selectedItems)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, items in
                owner.mainView.setButtonTitle(count: items.count)
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, route in
                switch route {
                case .dismissWithData:
                    owner.onCompleted?(true)
                    owner.dismiss(animated: true)
                case .dismiss:
                    owner.onCompleted?(false)
                    owner.dismiss(animated: true)
                case .addCollection:
                    let viewController = owner.addCollectionFactory.make(collection: nil)

                    guard let viewController = viewController as? AddCollectionViewController else { return }

                    viewController.dismissed
                        .withUnretained(self)
                        .subscribe { owner, _ in
                            owner.reactor?.action.onNext(.completeAdding)
                        }
                        .disposed(by: owner.disposeBag)

                    owner.present(viewController, animated: true)
                case .collectionError:
                    ToastFactory.createToast(message: "컬렉션 저장에 실패했어요. 다시 시도해주세요.")
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
            let collection = reactor.currentState.collections[indexPath.row - 1]
            let isSelected = reactor.currentState.selectedItems.contains(where: { $0.collectionId == collection.collectionId })
            cell.isChecked = isSelected
            cell.inject(title: collection.name)
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            reactor?.action.onNext(.addCollectionTapped)
        } else {
            guard let collection = reactor?.currentState.collections[indexPath.row - 1] else { return }
            reactor?.action.onNext(.selectItem(collection.collectionId))
        }
    }
}
