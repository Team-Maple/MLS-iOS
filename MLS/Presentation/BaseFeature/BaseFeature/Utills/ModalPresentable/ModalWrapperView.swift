import UIKit

internal import DesignSystem

final class ModalWrapperView: UIView {
    
    weak var parentViewController: UIViewController?

    let dimView = UIView()
    let containerView = UIView()
    let gestureBar = UIView()
    
    private var initialY: CGFloat = 0

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

        // 탭 시 모달 닫기
        let tap = UITapGestureRecognizer(target: parent, action: #selector(parent.dismissCurrentModal))
        dimView.addGestureRecognizer(tap)

        // 모달 컨테이너
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = ModalConfig.containerCornerRadius
        containerView.clipsToBounds = true
        containerView.transform = CGAffineTransform(translationX: 0, y: ModalConfig.containerTransformY)
        addSubview(containerView)

        containerView.snp.makeConstraints { make in
            switch contentViewController.modalStyle {
            case .bottomSheet:
                make.horizontalEdges.bottom.equalToSuperview()
            case .modal:
                make.bottom.equalTo(safeAreaLayoutGuide).inset(ModalConfig.containerBottomInset)
                make.horizontalEdges.equalToSuperview().inset(ModalConfig.containerHorizontalInset)
            }
        }

        gestureBar.backgroundColor = .neutral200
        gestureBar.layer.cornerRadius = ModalConfig.gestureBarHeight / 2
        gestureBar.clipsToBounds = true
        containerView.addSubview(gestureBar)
        gestureBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(ModalConfig.gestureBarTopInset)
            make.height.equalTo(ModalConfig.gestureBarHeight)
            make.width.equalTo(ModalConfig.gestureBarWidth)
            make.centerX.equalToSuperview()
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        containerView.addGestureRecognizer(panGesture)
        
        // 자식 뷰컨트롤러 embed
        parent.addChild(contentViewController)
        containerView.addSubview(contentViewController.view)
        contentViewController.view.snp.makeConstraints { make in
            switch contentViewController.modalStyle {
            case .bottomSheet:
                make.bottom.equalToSuperview().inset(ModalConfig.bottomSheetStyleBottomInset)
                make.top.equalToSuperview().inset(ModalConfig.containerVerticalContentInset)
            case .modal:
                make.verticalEdges.equalToSuperview().inset(ModalConfig.containerVerticalContentInset)
            }
            make.horizontalEdges.equalToSuperview()
            if let height = contentViewController.modalHeight { make.height.equalTo(height) }
        }
        contentViewController.didMove(toParent: parent)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: containerView)
        
        switch gesture.state {
        case .began:
            // 초기화 필요 시 여기에
            break

        case .changed:
            // 아래로 드래그 할 때만 이동
            if translation.y > 0 {
                containerView.transform = CGAffineTransform(translationX: 0, y: translation.y)
                dimView.alpha = max(0, 1 - (translation.y / 300))
            }

        case .ended, .cancelled:
            let velocity = gesture.velocity(in: containerView).y
            let shouldDismiss = translation.y > 150 || velocity > 1000

            if shouldDismiss {
                UIView.animate(withDuration: 0.25, animations: {
                    self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.bounds.height)
                    self.dimView.alpha = 0
                }, completion: { _ in
                    self.parentViewController?.dismissCurrentModal()
                })
            } else {
                // 복귀 애니메이션
                UIView.animate(withDuration: 0.25, animations: {
                    self.containerView.transform = .identity
                    self.dimView.alpha = 1
                })
            }
        default:
            break
        }
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
