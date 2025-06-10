import UIKit

import BaseFeature

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final public class ItemFilterBottomSheetViewController: BaseViewController, ModalPresentable, View {
    public var modalHeight: CGFloat? = 500
    
    public var modalStyle: ModalStyle = .bottomSheet
    
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
    func addViews() { }

    func setupConstraints() { }

    func configureUI() { }
}

extension ItemFilterBottomSheetViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    
    func bindUserActions(reactor: Reactor) {
    }
    
    func bindViewState(reactor: Reactor) {
    }
}
