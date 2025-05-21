import UIKit

import BaseFeature

internal import SnapKit
internal import RxCocoa
internal import RxSwift
import ReactorKit

public class OnBoardingQuestionViewController: BaseViewController {
    // MARK: - Properties
    
    // MARK: - Components
    public var disposeBag = DisposeBag()
    
    private var mainView = OnBoardingQuestionView()
}

// MARK: - Life Cycle
extension OnBoardingQuestionViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
    
    func configureUI() {
        addViews() 
        setupConstraints()
    }
}

// MARK: - Private Methods
private extension OnBoardingQuestionViewController {
    
}

// MARK: - Bind
public extension OnBoardingQuestionViewController {
    
}
