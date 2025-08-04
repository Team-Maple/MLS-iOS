import UIKit

import DesignSystem
import SnapKit

private var modalWrapperKey: UInt8 = 0

public extension UIViewController {

    private var modalWrapperView: ModalWrapperView? {
        get { objc_getAssociatedObject(self, &modalWrapperKey) as? ModalWrapperView }
        set { objc_setAssociatedObject(self, &modalWrapperKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// 커스텀 모달 프레젠트
    func presentModal(_ viewController: UIViewController & ModalPresentable) {
        let wrapper = ModalWrapperView(contentViewController: viewController, parent: self)
        modalWrapperView = wrapper
        view.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // present 애니메이션
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.8, options: [.curveEaseOut]) {
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

        wrapper.animateDismiss {
            if let contentVC = wrapper.containerView.subviews.compactMap({ $0.next as? UIViewController }).first {
                contentVC.willMove(toParent: nil)
                contentVC.view.removeFromSuperview()
                contentVC.removeFromParent()
            }

            wrapper.removeFromSuperview()
            self.modalWrapperView = nil
        }
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
