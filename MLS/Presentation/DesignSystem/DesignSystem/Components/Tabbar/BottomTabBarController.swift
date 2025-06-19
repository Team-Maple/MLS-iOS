import UIKit

import SnapKit

public final class BottomTabBarController: UITabBarController {
    // MARK: - Components
    private let tabItems: [TabItem]
    private let customTabBar: BottomTabBar

    // MARK: - Init
    public init(viewControllers: [UIViewController], initialIndex: Int = 0) {
        tabItems = [
            TabItem(title: "추천", icon: .favorite),
            TabItem(title: "도감", icon: .dictionary),
            TabItem(title: "북마크", icon: .bookmark),
            TabItem(title: "MY", icon: .mypage)
        ]
        customTabBar = BottomTabBar(tabItems: tabItems, selectedIndex: initialIndex)
        super.init(nibName: nil, bundle: nil)
        configureUI(controllers: viewControllers)
        selectedIndex = initialIndex
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
    }
}

// MARK: - SetUp
private extension BottomTabBarController {
    func addViews() {
        view.addSubview(customTabBar)
    }

    func setupConstraints() {
        customTabBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func configureUI(controllers: [UIViewController]) {
        viewControllers = controllers.map {
            if $0 is UINavigationController {
                return $0
            } else {
                return UINavigationController(rootViewController: $0)
            }
        }
        tabBar.isHidden = true

        customTabBar.onTabSelected = { [weak self] index in
            self?.selectedIndex = index
        }
    }
}

public extension BottomTabBarController {
    func setHidden(hidden: Bool, animated: Bool = true) {
        guard customTabBar.isHidden != hidden else { return }

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.customTabBar.alpha = hidden ? 0 : 1
            } completion: { _ in
                self.customTabBar.isHidden = hidden
            }
        } else {
            customTabBar.isHidden = hidden
            customTabBar.alpha = hidden ? 0 : 1
        }
    }
}
