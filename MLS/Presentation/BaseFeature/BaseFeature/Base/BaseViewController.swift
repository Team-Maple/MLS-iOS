import os
import UIKit

import DesignSystem

open class BaseViewController: UIViewController {
    open var isBottomTabbarHidden: Bool = false

    public init() {
        super.init(nibName: nil, bundle: nil)
        os_log("➕init: \(String(describing: self))")
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        os_log("➖deinit: \(String(describing: self))")
    }
}

// MARK: - Life Cycle
extension BaseViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let tabBarController = self.tabBarController as? BottomTabBarController {
            tabBarController.setHidden(hidden: isBottomTabbarHidden, animated: animated)
        }
    }
}

// MARK: - SetUp
private extension BaseViewController {
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground
    }
}
