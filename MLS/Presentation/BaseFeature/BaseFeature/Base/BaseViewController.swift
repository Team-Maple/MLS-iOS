import UIKit
import os

open class BaseViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        os_log("init: \(String(describing: self))")
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension BaseViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - SetUp
private extension BaseViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}
