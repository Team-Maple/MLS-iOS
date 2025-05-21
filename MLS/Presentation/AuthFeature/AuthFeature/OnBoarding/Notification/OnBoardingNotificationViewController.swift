import UIKit

internal import SnapKit
internal import RxCocoa
internal import RxSwift
import ReactorKit

public class OnBoardingNotificationViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Components
    public var disposeBag = DisposeBag()
    
    private var mainView = OnBoardingNotificationView()
}

// MARK: - Life Cycle
extension OnBoardingNotificationViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - SetUp
private extension OnBoardingNotificationViewController {
    func addViews() {
        view.addSubview(mainView)
    }
    
    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        addViews()
        setupConstraints()
        
        view.backgroundColor = .whiteMLS
    }
}

// MARK: - Private Methods
private extension OnBoardingNotificationViewController {
    
}

// MARK: - Bind
public extension OnBoardingNotificationViewController {
    
}
