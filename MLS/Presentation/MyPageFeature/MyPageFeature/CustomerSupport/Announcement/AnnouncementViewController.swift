import UIKit

import DomainInterface

import ReactorKit

final class AnnouncementViewController: CustomerSupportBaseViewController, View {
    typealias Reactor = AnnouncementReactor
    
    // MARK: - Init
    override init(type: CustomerSupportType) {
        super.init(type: type)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 타입을 나눠서 베이스에서 다 처리하는게 나을려나??
        mainView.setMenuHidden(true)
        mainView.changeeSetupConstraints()
    }
}

// MARK: - Bind
extension AnnouncementViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {}

    func bindViewState(reactor: Reactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.alarms)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, item in
                owner.createDetailItem(items: reactor.currentState.alarms)
            })
            .disposed(by: disposeBag)
    }
}
