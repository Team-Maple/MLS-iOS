import UIKit

import BaseFeature
import BookmarkFeatureInterface
import DesignSystem
import DomainInterface

import ReactorKit
import RxKeyboard
import RxSwift
import SnapKit

public final class BookmarkModalViewController: BaseViewController, View {
    public typealias Reactor = BookmarkModalReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()
    private var isPresentingAddCollection = false
    public var onDismissWithMessage: ((String) -> Void)?

    // MARK: - Components
    private let mainView = BookmarkModalView()
    private let addCollectionView = AddCollectionView()
    private let addCollectionContainer = UIView()
    private let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()

    // MARK: - Init
    override public init() {
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

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboard()
    }
}

// MARK: - Setup
private extension BookmarkModalViewController {
    func addViews() {
        view.addSubview(mainView)
        view.addSubview(dimmedBackgroundView)
        view.addSubview(addCollectionContainer)

        addCollectionContainer.addSubview(addCollectionView)

        addCollectionContainer.clipsToBounds = true
        addCollectionContainer.layer.cornerRadius = 16
        addCollectionContainer.backgroundColor = .white

        addCollectionContainer.isHidden = true
        addCollectionView.isHidden = false
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        addCollectionContainer.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        addCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        mainView.folderCollectionView.collectionViewLayout = createListLayout()
        mainView.folderCollectionView.delegate = self
        mainView.folderCollectionView.dataSource = self

        mainView.folderCollectionView.register(AddFolderCell.self, forCellWithReuseIdentifier: AddFolderCell.identifier)
        mainView.folderCollectionView.register(FolderCell.self, forCellWithReuseIdentifier: FolderCell.identifier)
    }

    func setupKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                let safeBottom = self.view.safeAreaInsets.bottom
                let inset = height > 0 ? height - safeBottom + AddCollectionView.Constant.buttonBottomMargin : AddCollectionView.Constant.buttonBottomMargin
                self.addCollectionView.addButtonBottomConstraint?.update(inset: inset)
            })
            .disposed(by: disposeBag)
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
        bindAddCollectionView(reactor: reactor)
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
            .distinctUntilChanged()
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
                case .dismissModal:
                    owner.hideAddCollectionView()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindAddCollectionView(reactor: Reactor) {
        addCollectionView.inputTextField.rx.text
            .map { Reactor.Action.inputTextChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        addCollectionView.backButton.rx.tap
            .map { Reactor.Action.modalBackButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        addCollectionView.completeButton.rx.tap
            .map { Reactor.Action.completeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isError)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isError in
                self?.addCollectionView.setError(isError: isError)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isButtonEnabled)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnabled in
                self?.addCollectionView.setButtonEnabled(isEnabled: isEnabled)
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
            let title = reactor.currentState.collections[indexPath.row - 1]
            cell.inject(title: title)
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            showAddCollectionView()
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? FolderCell else { return }
            cell.toggleSelected()
        }
    }
}

// MARK: - Bottom Sheet Presentation
private extension BookmarkModalViewController {
    func showAddCollectionView() {
        isPresentingAddCollection = true
        dimmedBackgroundView.alpha = 0
        dimmedBackgroundView.isHidden = false
        addCollectionContainer.isHidden = false
        addCollectionContainer.transform = CGAffineTransform(translationX: 0, y: 400)

        UIView.animate(withDuration: 0.25) {
            self.dimmedBackgroundView.alpha = 1
            self.addCollectionContainer.transform = .identity
        }

        addCollectionView.inputTextField.text = nil
        addCollectionView.setError(isError: false)
        addCollectionView.setButtonEnabled(isEnabled: false)
        addCollectionView.inputTextField.becomeFirstResponder()
    }

    func hideAddCollectionView() {
        isPresentingAddCollection = false
        addCollectionView.endEditing(true)

        UIView.animate(withDuration: 0.25, animations: {
            self.dimmedBackgroundView.alpha = 0
            self.addCollectionContainer.transform = CGAffineTransform(translationX: 0, y: 400)
        }, completion: { _ in
            self.addCollectionContainer.isHidden = true
            self.dimmedBackgroundView.isHidden = true
        })

        dismiss(animated: true) { [weak self] in
            if let name = self?.reactor?.currentState.currentInput, !name.isEmpty {
                self?.onDismissWithMessage?(name)
            }
        }
    }
}
