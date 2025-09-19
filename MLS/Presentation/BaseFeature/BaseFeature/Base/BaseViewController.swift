import os
import UIKit

import DesignSystem

import RxKeyboard
import RxSwift

open class BaseViewController: UIViewController {
    private let disposeBag = DisposeBag()

    open var isBottomTabbarHidden: Bool = false {
        didSet {
            if let tabBarController = tabBarController as? BottomTabBarController {
                tabBarController.setHidden(hidden: isBottomTabbarHidden, animated: false)
            }
        }
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        os_log("➕init: \(String(describing: self))")
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        os_log("➖deinit: \(String(describing: self))")
    }
}

// MARK: - Life Cycle
extension BaseViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let tabBarController = tabBarController as? BottomTabBarController {
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

// MARK: - Methods
public extension BaseViewController {
    func setupKeyboard(inset: CGFloat = 0, completion: @escaping (CGFloat) -> Void) {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                let safeBottom = self.view.safeAreaInsets.bottom
                let inset = height > 0
                    ? height - safeBottom + inset
                    : inset
                completion(inset)
            })
            .disposed(by: disposeBag)
    }
}
