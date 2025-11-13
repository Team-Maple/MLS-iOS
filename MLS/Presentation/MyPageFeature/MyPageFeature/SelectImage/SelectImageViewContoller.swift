import UIKit

import BaseFeature
import DesignSystem
import DomainInterface

import ReactorKit
import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit

public final class SelectImageViewContoller: BaseViewController, ModalPresentable, View {
    // 수정필요
    public var modalHeight: CGFloat? = 16 + 32 + UIScreen.main.bounds.size.width + 4 + 24 + 54 + 4

    public typealias Reactor = SelectImageReactor

    public var disposeBag = DisposeBag()

    // MARK: - Components

    private var mainView = SelectImageView()
}

// MARK: - Life Cycle
public extension SelectImageViewContoller {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension SelectImageViewContoller {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        mainView.imageCollectionView.collectionViewLayout = createLayout()
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
        mainView.imageCollectionView.register(SelectImageCell.self, forCellWithReuseIdentifier: SelectImageCell.identifier)
    }

    func createLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getSelectImageLayout() }
            .build()
        return layout
    }
}

extension SelectImageViewContoller {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.header.firstIconButton.rx.tap
            .map { Reactor.Action.cancelButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.applyButton.rx.tap
            .map { Reactor.Action.applyButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.dismissCurrentModal()
                case .dismissWithSave:
                    owner.dismissCurrentModal()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SelectImageViewContoller: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.images.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectImageCell.identifier, for: indexPath) as? SelectImageCell,
              let reactor = reactor else { return UICollectionViewCell() }
        cell.inject(input: SelectImageCell.Input(type: reactor.currentState.images[indexPath.row]))
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let reactor = reactor else { return }
        reactor.action.onNext(.imageTapped(indexPath.row))
    }
}
