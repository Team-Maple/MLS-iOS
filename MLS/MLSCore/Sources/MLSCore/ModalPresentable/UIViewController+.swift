import UIKit

import DesignSystem

import SnapKit

private var modalWrapperKey: UInt8 = 0
private var modalHideTabBarKey: UInt8 = 0

public extension UIViewController {

    private var modalWrapperView: ModalWrapperView? {
        get { objc_getAssociatedObject(self, &modalWrapperKey) as? ModalWrapperView }
        set { objc_setAssociatedObject(self, &modalWrapperKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var modalHideTabBar: Bool {
        get { (objc_getAssociatedObject(self, &modalHideTabBarKey) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &modalHideTabBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// 커스텀 모달 프레젠트
    /// - Parameters:
    ///   - viewController: 표시할 모달 뷰컨
    ///   - hideTabBar: 탭바를 숨길지 여부 (기본값: true)
    func presentModal(
        _ viewController: UIViewController & ModalPresentable,
        hideTabBar: Bool = false
    ) {
        let wrapper = ModalWrapperView(contentViewController: viewController, parent: self)

        // 이전 상태 초기화
        modalHideTabBar = false
        modalWrapperView = wrapper

        // 새 설정 적용
        modalHideTabBar = hideTabBar

        view.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 필요 시 탭바 숨김
        if hideTabBar, let tabBarController = findTabBarController() {
            tabBarController.setHidden(hidden: true, animated: false)
        }

        // present 애니메이션
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.8,
            options: [.curveEaseOut]
        ) {
            wrapper.dimView.alpha = 1
            wrapper.containerView.transform = .identity
            DispatchQueue.main.async {
                viewController.beginAppearanceTransition(true, animated: true)
                viewController.endAppearanceTransition()
            }
        }
    }

    /// 현재 모달 닫기
    @objc internal func dismissCurrentModal() {
        guard let wrapper = modalWrapperView else { return }

        let shouldKeepHidden = modalHideTabBar
        let tabBarController = findTabBarController()

        if shouldKeepHidden, let tabBarController {
            tabBarController.setHidden(hidden: true, animated: false)
        }

        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut]) {
            wrapper.dimView.alpha = 0
            wrapper.containerView.transform = CGAffineTransform(translationX: 0, y: 300)
        } completion: { _ in
            wrapper.removeFromSuperview()
            self.modalWrapperView = nil

            // false인 경우 복원
            if !shouldKeepHidden, let tabBarController {
                tabBarController.setHidden(hidden: false, animated: false)
            }

            self.modalHideTabBar = false
        }
    }

    private func findTabBarController() -> BottomTabBarController? {
        var parentVC: UIViewController? = self
        while let current = parentVC {
            if let tabBarController = current as? BottomTabBarController {
                return tabBarController
            }
            parentVC = current.parent
        }
        return nil
    }
}

// 모달 내부에서 닫기 기능 제공
extension ModalPresentable where Self: UIViewController {
    public func dismissCurrentModal() {
        parent?.dismissCurrentModal()
    }
}

private var fabKey: UInt8 = 0

public extension UIViewController {
    func addFloatingButton(_ action: @escaping () -> Void) {
        let fab = FloatingActionButton(action: action)
        objc_setAssociatedObject(self, &fabKey, fab, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        view.addSubview(fab)
        fab.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
    }

    func removeFloatingButton() {
        if let fab = objc_getAssociatedObject(self, &fabKey) as? UIView {
            fab.removeFromSuperview()
            objc_setAssociatedObject(self, &fabKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
