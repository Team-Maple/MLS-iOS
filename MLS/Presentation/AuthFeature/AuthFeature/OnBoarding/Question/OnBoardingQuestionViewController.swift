import UIKit

internal import SnapKit
internal import RxCocoa
internal import RxSwift
import ReactorKit

public class onBoardingQuestionViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Components
    public var disposeBag = DisposeBag()
    
    private var mainView = onBoardingQuestionView()
}

// MARK: - Life Cycle
extension onBoardingQuestionViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - SetUp
private extension onBoardingQuestionViewController {
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
private extension onBoardingQuestionViewController {
    
}

// MARK: - Bind
public extension onBoardingQuestionViewController {
    
}
