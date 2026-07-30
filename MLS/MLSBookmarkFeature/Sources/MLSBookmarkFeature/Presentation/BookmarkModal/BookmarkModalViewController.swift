import MLSBookmarkFeatureInterface
import MLSCore
import MLSDesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class BookmarkModalViewController: BaseViewController, View {
    typealias Reactor = BookmarkModalReactor

    var disposeBag = DisposeBag()
    var onCompleted: ((Bool) -> Void)?

    private let addCollectionFactory: AddCollectionFactory
    private let mainView = BookmarkModalView()

    init(addCollectionFactory: AddCollectionFactory) {
        self.addCollectionFactory = addCollectionFactory
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
    }
}

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
        CompositionalLayoutBuilder()
            .section { _ in LayoutFactory.getCollectionModalLayout() }
            .build()
    }
}

extension BookmarkModalViewController {
    func bind(reactor: Reactor) {
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
                    guard let vc = viewController as? AddCollectionViewController else { return }
                    vc.dismissed
                        .withUnretained(owner)
                        .subscribe { o, _ in
                            o.reactor?.action.onNext(.completeAdding)
                        }
                        .disposed(by: owner.disposeBag)
                    owner.present(vc, animated: true)
                case .collectionError:
                    ToastFactory.createToast(message: "컬렉션 저장에 실패했어요. 다시 시도해주세요.")
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

extension BookmarkModalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (reactor?.currentState.collections.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: AddFolderCell.identifier, for: indexPath) as? AddFolderCell ?? UICollectionViewCell()
        }
        guard let reactor, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.identifier, for: indexPath) as? FolderCell else {
            return UICollectionViewCell()
        }
        let collection = reactor.currentState.collections[indexPath.row - 1]
        let isSelected = reactor.currentState.selectedItems.contains(where: { $0.collectionId == collection.collectionId })
        cell.isChecked = isSelected
        cell.inject(title: collection.name)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            reactor?.action.onNext(.addCollectionTapped)
        } else {
            guard let collection = reactor?.currentState.collections[indexPath.row - 1] else { return }
            reactor?.action.onNext(.selectItem(collection.collectionId))
        }
    }
}
