import UIKit

import DesignSystem

import SnapKit
import RxSwift

final class ToastMakerTestViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    let toast = Toast(message: "토스트 테스트")
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Toast"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension ToastMakerTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews()
        self.setupContstraints()
        self.configureUI()
    }
}

// MARK: - SetUp
private extension ToastMakerTestViewController {
    func addViews() {
        self.view.addSubview(toast)
    }

    func setupContstraints() {
        toast.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        self.view.backgroundColor = .systemBackground
    }
}
