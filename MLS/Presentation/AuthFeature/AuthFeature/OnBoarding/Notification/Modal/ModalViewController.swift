import UIKit

import BaseFeature

internal import SnapKit
internal import RxCocoa
internal import RxSwift
import ReactorKit

final class ModalViewController: BaseViewController, View, ModalPresentable {
    // MARK: - Properties
    typealias Reactor = ModalReactor
    
    var disposeBag = DisposeBag()
    
    var modalHeight: CGFloat?
    var modalStyle: ModalStyle
    
    private var mainView = ModalView()
    
    init(modalHeight: CGFloat? = nil, modalStyle: ModalStyle) {
        self.modalHeight = modalHeight
        self.modalStyle = modalStyle
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension ModalViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension ModalViewController {
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

extension ModalViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    
    func bindUserActions(reactor: Reactor) {
        mainView.agreeButton.rx.tap
            .map { Reactor.Action.agreeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.disagreeButton.rx.tap
            .map { Reactor.Action.disagreeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindViewState(reactor: Reactor) {
        reactor.pulse(\.$route)
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
