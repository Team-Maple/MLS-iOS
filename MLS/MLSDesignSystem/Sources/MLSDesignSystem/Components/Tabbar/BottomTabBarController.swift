import UIKit

import SnapKit

public final class BottomTabBarController: UITabBarController {
    // MARK: - Type
    private enum Constant {
        static let horizontalInset: CGFloat = 24
        static let commentBottomMargin: CGFloat = -8
        static let commentWidth: CGFloat = 152
        static let commentHeight: CGFloat = 28
        static let buttonSize: CGFloat = 64
        static let arrowInset: CGFloat = 16
        @MainActor static let spacing: CGFloat = (UIScreen.main.bounds.width - (horizontalInset * 2) - (buttonSize * 4)) / 3
        @MainActor static let commentLeadingOffset: CGFloat = horizontalInset + buttonSize + spacing + (buttonSize / 2) - arrowInset
    }

    // MARK: - Components
    private let divider = DividerView()
    private let tabItems: [TabItem]
    private let customTabBar: BottomTabBar
    private let tabBarBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private let recommendationCommentView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "recommendationComment")
        view.isHidden = true
        return view
    }()

    // MARK: - Init
    public init(viewControllers: [UIViewController], tabItems: [TabItem]? = nil, initialIndex: Int = 0) {
        let resolvedItems = tabItems ?? [
            TabItem(title: "도감", icon: DesignSystemAsset.image(named: "dictionary")),
            TabItem(title: "북마크", icon: DesignSystemAsset.image(named: "bookmarkList")),
            TabItem(title: "MY", icon: DesignSystemAsset.image(named: "mypage"))
        ]
        self.tabItems = resolvedItems
        customTabBar = BottomTabBar(tabItems: resolvedItems, selectedIndex: initialIndex)
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
        view.addSubview(tabBarBackground)
        view.addSubview(customTabBar)
        view.addSubview(divider)
        view.addSubview(recommendationCommentView)
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

        tabBarBackground.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(divider.snp.top)
        }

        recommendationCommentView.snp.makeConstraints { make in
            make.bottom.equalTo(customTabBar.snp.top).offset(Constant.commentBottomMargin)
            make.leading.equalTo(view.snp.leading).offset(Constant.commentLeadingOffset)
            make.width.equalTo(Constant.commentWidth)
            make.height.equalTo(Constant.commentHeight)
        }
    }

    func configureUI(controllers: [UIViewController]) {
        viewControllers = controllers.map {
            let nav: UINavigationController
            if let existing = $0 as? UINavigationController {
                nav = existing
            } else {
                nav = UINavigationController(rootViewController: $0)
            }
            nav.delegate = self
            return nav
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

extension BottomTabBarController: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let isRoot = navigationController.viewControllers.count == 1
        setHidden(hidden: !isRoot, animated: isRoot && animated)
    }
}

public extension BottomTabBarController {
    func setHidden(hidden: Bool, animated: Bool = false) {
        guard customTabBar.isHidden != hidden else { return }

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.customTabBar.alpha = hidden ? 0 : 1
                self.divider.alpha = hidden ? 0 : 1
                self.tabBarBackground.alpha = hidden ? 0 : 1
            } completion: { _ in
                self.customTabBar.isHidden = hidden
                self.divider.isHidden = hidden
                self.tabBarBackground.isHidden = hidden
            }
        } else {
            customTabBar.isHidden = hidden
            customTabBar.alpha = hidden ? 0 : 1
            divider.isHidden = hidden
            divider.alpha = hidden ? 0 : 1
            tabBarBackground.isHidden = hidden
            tabBarBackground.alpha = hidden ? 0 : 1
        }
    }

    func selectTab(index: Int, animated: Bool = false) {
        UIView.performWithoutAnimation {
            selectedIndex = index
            customTabBar.selectTab(index: index)
        }
    }

    func checkRecommendationFirstLaunch(isFirst: Bool) {
        recommendationCommentView.isHidden = isFirst
    }
}
