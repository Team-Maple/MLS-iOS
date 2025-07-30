import UIKit

import BaseFeature

import ReactorKit
import RxSwift
import SnapKit

public final class MonsterFilterBottomSheetViewController: BaseViewController, ModalPresentable, View {
    public var modalHeight: CGFloat? = 306

    public typealias Reactor = MonsterFilterBottomSheetReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private var mainView = MonsterFilterBottomSheetView()
}

// MARK: - Life Cycle
public extension MonsterFilterBottomSheetViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension MonsterFilterBottomSheetViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {}
}

extension MonsterFilterBottomSheetViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.header.firstIconButton.rx.tap
            .map { Reactor.Action.cancelButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.dismissCurrentModal()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
