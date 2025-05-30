import os
import UIKit

import BaseFeature
import AuthFeatureInterface

import ReactorKit
internal import RxCocoa
internal import RxSwift
internal import SnapKit

public class OnBoardingQuestionViewController: BaseViewController, View {
    // MARK: - Properties
    public typealias Reactor = OnBoardingQuestionReactor
    private let factory: OnBoardingFactory
    
    // MARK: - Components
    public var disposeBag = DisposeBag()
    
    private var mainView = OnBoardingQuestionView()
    
    public init(factory: OnBoardingFactory) {
        self.factory = factory
        super.init()
    }
    
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
        showToast()
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

// MARK: - Methods
private extension OnBoardingQuestionViewController {
    func showToast() {
        reactor?.action.onNext(.enterScene)
    }
}

// MARK: - Bind
public extension OnBoardingQuestionViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
        
    func bindUserActions(reactor: Reactor) {
        mainView.nextButton.rx.tap
            .map { Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.headerView.leftButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
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
        
        reactor.pulse(\.$route)
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .home:
                    os_log("moveToHome")
                    break
                case .input:
                    let vc = owner.factory.make()
                    owner.navigationController?.pushViewController(vc, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
