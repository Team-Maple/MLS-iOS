import UIKit

import BaseFeature

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final public class ItemFilterBottomSheetViewController: BaseViewController, View {
    
    public typealias Reactor = ItemFilterBottomSheetViewReactor
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    private var mainView = ItemFilterBottomSheetView()
    
    public override init() {
        super.init()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension ItemFilterBottomSheetViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension ItemFilterBottomSheetViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() { }
}

extension ItemFilterBottomSheetViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    
    func bindUserActions(reactor: Reactor) {
        mainView.headerView.firstIconView.rx.tap
            .map { Reactor.Action.closeButtonTapped }
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
                    owner.dismiss(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

    }
}
