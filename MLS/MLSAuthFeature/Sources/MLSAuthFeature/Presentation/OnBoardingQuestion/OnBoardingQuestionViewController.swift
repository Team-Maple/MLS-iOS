import UIKit

import AuthFeatureInterface
import BaseFeature

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public class OnBoardingQuestionViewController: BaseViewController, View {
    // MARK: - Properties
    public typealias Reactor = OnBoardingQuestionReactor

    public var disposeBag = DisposeBag()

    private let onBoardingInputFactory: OnBoardingInputFactory

    // MARK: - Components

    private var mainView = OnBoardingQuestionView()

    public init(factory: OnBoardingInputFactory) {
        self.onBoardingInputFactory = factory
        super.init()
    }

    @available(*, unavailable)
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension OnBoardingQuestionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
    }
}

// MARK: - SetUp
private extension OnBoardingQuestionViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind
public extension OnBoardingQuestionViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.nextButton.rx.tap
            .map { Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.headerView.leftButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.headerView.underlineTextButton.rx.tap
            .map { Reactor.Action.skipButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.pulse(\.$isShowToast)
            .subscribe { isShowToast in
                if isShowToast {
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy.MM.dd"
                    let formattedDate = dateFormatter.string(from: currentDate)
                    ToastFactory.createToast(message: "\(formattedDate) 약관에 동의했어요.")
                }
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .home:
                    let homeViewController = UIViewController()
                    homeViewController.view.backgroundColor = .green
                    owner.navigationController?.pushViewController(homeViewController, animated: true)
                case .input:
                    let inputViewController = owner.onBoardingInputFactory.make()
                    owner.navigationController?.pushViewController(inputViewController, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
