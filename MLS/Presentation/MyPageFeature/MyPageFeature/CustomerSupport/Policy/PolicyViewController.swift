import UIKit

import BaseFeature
import DesignSystem
import DomainInterface
import MyPageFeatureInterface

import RxCocoa
import RxGesture
import RxSwift
/*
**부모 뷰컨이 될 것 같음**
 */
class PolicyViewController: BaseViewController {
    // MARK: - Properties
    public var disposeBag = DisposeBag()

    // MARK: - Components
    public var mainView: PolicyView

    public init(type: PolicyType) {
        self.mainView = PolicyView(type: type)
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstaraints()
        bind()
    }
}

// MARK: - SetUp
extension PolicyViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstaraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func bind() {
        mainView.headerView.leftButton.rx.tap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
