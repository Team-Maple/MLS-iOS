import UIKit
import SnapKit

public final class BottomTabBarController: UIViewController {
    // MARK: - Components
    private let divider = DividerView()
    private let tabItems: [TabItem]
    private let customTabBar: BottomTabBar
    private let controllers: [UIViewController]

    private var currentVC: UIViewController?

    // MARK: - Init
    public init(viewControllers: [UIViewController], initialIndex: Int = 0) {
        self.controllers = viewControllers.map {
            if $0 is UINavigationController {
                return $0
            } else {
                return UINavigationController(rootViewController: $0)
            }
        }
        self.tabItems = [
            TabItem(title: "도감", icon: .dictionary),
            TabItem(title: "북마크", icon: .bookmark),
            TabItem(title: "MY", icon: .mypage)
        ]
        self.customTabBar = BottomTabBar(tabItems: tabItems, selectedIndex: initialIndex)
        super.init(nibName: nil, bundle: nil)

        switchTo(index: initialIndex, animated: false)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        view.backgroundColor = .clearMLS

        customTabBar.onTabSelected = { [weak self] index in
            self?.switchTo(index: index)
        }
    }
}

// MARK: - Private
private extension BottomTabBarController {
    func addViews() {
        view.addSubview(customTabBar)
        view.addSubview(divider)
    }

    func setupConstraints() {
        divider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(customTabBar.snp.top)
        }

        customTabBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func switchTo(index: Int, animated: Bool = true) {
        let newVC = controllers[index]

        if let currentVC = currentVC {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }

        addChild(newVC)
        view.insertSubview(newVC.view, belowSubview: customTabBar)
        newVC.view.frame = view.bounds
        newVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newVC.didMove(toParent: self)

        currentVC = newVC
    }
}

// MARK: - Methods
public extension BottomTabBarController {
    func setHidden(hidden: Bool, animated: Bool = true) {
        guard customTabBar.isHidden != hidden else { return }

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.customTabBar.alpha = hidden ? 0 : 1
                self.divider.alpha = hidden ? 0 : 1
            } completion: { _ in
                self.customTabBar.isHidden = hidden
                self.divider.isHidden = hidden
            }
        } else {
            customTabBar.isHidden = hidden
            customTabBar.alpha = hidden ? 0 : 1
            divider.isHidden = hidden
            divider.alpha = hidden ? 0 : 1
        }
    }
}
