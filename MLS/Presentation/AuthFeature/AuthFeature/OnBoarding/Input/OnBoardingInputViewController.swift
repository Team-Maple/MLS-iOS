import UIKit

internal import SnapKit
internal import RxCocoa
internal import RxSwift
import ReactorKit

public class OnBoardingInputViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Components
    public var disposeBag = DisposeBag()
    
    private var mainView = OnBoardingInputView()
}

// MARK: - Life Cycle
extension OnBoardingInputViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - SetUp
private extension OnBoardingInputViewController {
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
        
        view.backgroundColor = .white0
    }
}

// MARK: - Private Methods
private extension OnBoardingInputViewController {
    
}

// MARK: - Bind
public extension OnBoardingInputViewController {
    
}
