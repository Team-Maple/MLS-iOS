import UIKit

internal import SnapKit
import RxCocoa
internal import RxSwift
import ReactorKit

public final class BaseErrorViewController: BaseViewController {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    public override init() {
        super.init()
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
    }
}

// MARK: - SetUp
private extension BaseErrorViewController {
    func addViews() { }

    func setupConstraints() { }

    func configureUI() { }
}
