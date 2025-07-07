import UIKit

import BaseFeature
import DomainInterface

import ReactorKit
import RxSwift

public final class BookmarkModalViewController: BaseViewController, View {
    public typealias Reactor = BookmarkModalReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    // MARK: - Components
    private let mainView: BookmarkModalView

    public override init() {
        self.mainView = BookmarkModalView()
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
        let layout = CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getCollectionModalLayout() }
            .build()
        return layout
    }
}

// MARK: - Bind
extension BookmarkModalViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.collections)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, item in
                owner.mainView.setButtonTitle(count: item.count)
                owner.mainView.folderCollectionView.reloadData()
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.dismiss(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension BookmarkModalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (reactor?.currentState.collections.count ?? 0) + 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddFolderCell.identifier,
                for: indexPath
            ) as? AddFolderCell else {
                return UICollectionViewCell()
            }
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FolderCell.identifier,
                for: indexPath
            ) as? FolderCell else {
                return UICollectionViewCell()
            }
            
            guard let reactor = reactor else { return UICollectionViewCell() }
            let title = reactor.currentState.collections[indexPath.row - 1]
            cell.inject(title: title)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? FolderCell else {
            return
        }
        cell.toggleSelected()
    }
}
