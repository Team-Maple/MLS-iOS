import UIKit

import DesignSystem

import SnapKit

final class ModalWrapperView: UIView {

    weak var parentViewController: UIViewController?

    let dimView = UIView()
    let containerView = UIView()

    private var initialY: CGFloat = 0
    private var containerBottomConstraint: Constraint?

    init(contentViewController: UIViewController & ModalPresentable, parent: UIViewController) {
        super.init(frame: .zero)
        self.parentViewController = parent

        // 뒷배경 뷰 (반투명)
        dimView.backgroundColor = .overlays
        dimView.alpha = 0
        addSubview(dimView)
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        if contentViewController.allowsTapToDismiss {
            // 탭 시 모달 닫기
            let tap = UITapGestureRecognizer(target: parent, action: #selector(parent.dismissCurrentModal))
            dimView.addGestureRecognizer(tap)
        }

        // 모달 컨테이너
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = ModalConfig.containerCornerRadius
        containerView.clipsToBounds = true
        containerView.transform = CGAffineTransform(translationX: 0, y: ModalConfig.containerTransformY)
        addSubview(containerView)

        containerView.snp.makeConstraints { make in
            self.containerBottomConstraint = make.bottom.equalToSuperview().constraint
            make.horizontalEdges.equalToSuperview()
        }

        // 자식 뷰컨트롤러 embed
        parent.addChild(contentViewController)
        containerView.addSubview(contentViewController.view)
        contentViewController.view.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(ModalConfig.bottomSheetStyleBottomInset)
            make.top.horizontalEdges.equalToSuperview()
            if let height = contentViewController.modalHeight { make.height.equalTo(height) }
        }
        contentViewController.didMove(toParent: parent)
    }

    func animateDismiss(completion: @escaping () -> Void) {
        if let bottomConstraint = containerBottomConstraint {
            // 아래로 내리기 위해 음수 inset
            bottomConstraint.update(inset: -containerView.bounds.height)
            UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseIn], animations: {
                self.layoutIfNeeded()
                self.dimView.alpha = 0
            }, completion: { _ in
                completion()
            })
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
