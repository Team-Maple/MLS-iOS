import UIKit

internal import DesignSystem

internal import SnapKit
import RxCocoa
internal import RxSwift
import ReactorKit

public final class BaseErrorViewController: BaseViewController {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    
    private let backButton = CommonButton(style: .normal, title: "뒤로가기", disabledTitle: nil)
    
    public override init() {
        super.init()
        modalPresentationStyle = .fullScreen
    }
    
    @MainActor public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension BaseErrorViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupConstraints()
        configureUI()
        bind()
    }
}

// MARK: - SetUp
private extension BaseErrorViewController {
    func addViews() {
        view.addSubview(backButton)
    }

    func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

    func configureUI() { }
    
    func bind() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
