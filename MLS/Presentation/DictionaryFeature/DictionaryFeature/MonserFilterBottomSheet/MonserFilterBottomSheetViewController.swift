import UIKit

import BaseFeature

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final public class MonserFilterBottomSheetViewController: BaseViewController, ModalPresentable, View {
    public var modalHeight: CGFloat?
    
    public typealias Reactor = MonserFilterBottomSheetReactor
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    private var mainView = MonserFilterBottomSheetView()
}

// MARK: - Life Cycle
extension MonserFilterBottomSheetViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension MonserFilterBottomSheetViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() { }
}

extension MonserFilterBottomSheetViewController {
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
            .flatMapLatest { _ in return reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { (owner, route) in
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
