import UIKit

import SnapKit

public final class BottomTabBarController: UITabBarController {
    // MARK: - Type
    private enum Constant {
        static let horizontalInset: CGFloat = 24
    }

    // MARK: - Components
    private let divider = DividerView()
    private let tabItems: [TabItem]
    private let customTabBar: BottomTabBar

    // MARK: - Init
    public init(viewControllers: [UIViewController], initialIndex: Int = 0) {
        tabItems = [
            TabItem(title: "도감", icon: .dictionary),
            TabItem(title: "북마크", icon: .bookmarkList),
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
        view.addSubview(divider)
    }

    func setupConstraints() {
        divider.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(customTabBar.snp.top)
        }

        customTabBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
            UIView.performWithoutAnimation {
                self?.selectedIndex = index
                self?.customTabBar.selectTab(index: index)
            }
        }
    }
}

public extension BottomTabBarController {
    func setHidden(hidden: Bool, animated: Bool = false) {
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

    func selectTab(index: Int, animated: Bool = false) {
        UIView.performWithoutAnimation {
            selectedIndex = index
            customTabBar.selectTab(index: index)
        }
    }
}
