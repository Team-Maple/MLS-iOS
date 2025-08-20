import UIKit

import BaseFeature

import ReactorKit
import RxKeyboard
import RxSwift
import SnapKit

public final class MonsterFilterBottomSheetViewController: BaseViewController, ModalPresentable, View {
    public var modalHeight: CGFloat?

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
        setupKeyboard()
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
    
    func setupKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                self?.mainView.snp.remakeConstraints { make in
                    make.top.horizontalEdges.equalToSuperview()
                    make.bottom.equalToSuperview().inset(height)
                }
            })
            .disposed(by: disposeBag)
    }
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
        
        mainView.tapGesture.rx.event
            .withUnretained(self)
            .bind { owner, gesture in
                let location = gesture.location(in: owner.mainView)
                
                if !owner.mainView.levelRangeView.leftInputBox.frame.contains(location) &&
                    !owner.mainView.levelRangeView.rightInputBox.frame.contains(location) {
                    owner.mainView.endEditing(true)
                }
            }
            .disposed(by: disposeBag)
    }
}
