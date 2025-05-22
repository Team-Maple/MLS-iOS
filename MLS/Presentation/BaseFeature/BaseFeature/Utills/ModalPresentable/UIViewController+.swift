import UIKit

internal import DesignSystem
internal import SnapKit

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
        }
    }

    /// 현재 모달 닫기
    @objc internal func dismissCurrentModal() {
        guard let wrapper = modalWrapperView else { return }

        let targetY = self.view.bounds.height

        // dismiss 애니메이션
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseIn], animations: {
            wrapper.dimView.alpha = 0
            wrapper.containerView.frame.origin.y = targetY
        }, completion: { _ in
            wrapper.removeFromSuperview()
            self.modalWrapperView = nil
        })
    }
}

// 모달 내부에서 닫기 기능 제공
extension ModalPresentable where Self: UIViewController {
    public func dismissCurrentModal() {
        parent?.dismissCurrentModal()
    }
}
