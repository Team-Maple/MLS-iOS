import UIKit

import MLSCore

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class RecommendationMainViewController: BaseViewController, View {
    
    typealias Reactor = RecommendationMainReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = RecommendationMainView()
}

// MARK: - Life Cycle
extension RecommendationMainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension RecommendationMainViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        mainView.profileView.configure(imageURL: nil, nickName: "익명의 판타지", job: "도적", level: 275)
    }
}

extension RecommendationMainViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    
    func bindUserActions(reactor: Reactor) {
    }
    
    func bindViewState(reactor: Reactor) {
    }
}
