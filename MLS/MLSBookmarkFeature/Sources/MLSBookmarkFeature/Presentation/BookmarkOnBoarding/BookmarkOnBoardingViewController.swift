import MLSCore
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class BookmarkOnBoardingViewController: BaseViewController, View {
    typealias Reactor = BookmarkOnBoardingReactor

    var disposeBag = DisposeBag()
    private let mainView = BookmarkOnBoardingView()

    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func bind(reactor: Reactor) {
        mainView.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.nextButton.rx.tap
            .map { Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe(onNext: { owner, route in
                switch route {
                case .dismiss:
                    owner.dismiss(animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.step)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, step in
                owner.mainView.configureUI(type: step)
            })
            .disposed(by: disposeBag)
    }
}
