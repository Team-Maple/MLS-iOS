import UIKit

import BaseFeature

internal import SnapKit
internal import RxCocoa
internal import RxSwift
import ReactorKit

final class ModalViewController: BaseViewController, View {
    
    typealias Reactor = ModalReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = ModalView()
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
    func addViews() { }

    func setupConstraints() { }

    func configureUI() { }
}

extension ModalViewController {
    func bind(reactor: Reactor) {
          bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    
    func bindUserActions(reactor: Reactor) {
    }
    
    func bindViewState(reactor: Reactor) {
    }
}
