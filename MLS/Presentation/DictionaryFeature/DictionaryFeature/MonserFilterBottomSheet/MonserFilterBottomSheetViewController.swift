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
    }
    
    func bindViewState(reactor: Reactor) {
    }
}
