import UIKit

import RxSwift
import SnapKit

@MainActor
public enum TooltipFactory {
    // MARK: - Properties

    /// 현재 디바이스 최상단 Window를 지정
    static var window: UIWindow? {
        UIApplication.shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }

    private static var currentTooltip: TooltipView?
    
    /// 전체 터치 dismiss용 overlay
    private static var overlayView: TooltipOverlayView?
}

public extension TooltipFactory {
    
    /// Tooltip 노출 메소드
    static func show(
        text: String,
        anchorView: UIView,
        tooltipPosition: TooltipPosition
    ) {
        currentTooltip?.removeFromSuperview()
        currentTooltip = nil

        guard let window = window else { return }

        /// 전체 영역 터치 dismiss overlay
        let overlay = TooltipOverlayView(frame: window.bounds)
        window.addSubview(overlay)
        overlayView = overlay

        let tooltip = TooltipView(text: text, tooltipPosition: tooltipPosition)
        overlay.addSubview(tooltip)
        currentTooltip = tooltip

        overlay.onDismiss = {
            dismiss()
        }

        let frame = anchorView.convert(anchorView.bounds, to: window)

        tooltip.frame.origin = CGPoint(x: 0, y: 0)
        tooltip.setNeedsLayout()
        tooltip.layoutIfNeeded()

        let tooltipSize = tooltip.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )

        /// arrow가 툴팁 내부에서 위치하는 고정 inset
        let arrowInset: CGFloat = 28
        let anchorCenterX = frame.midX

        /// 툴팁 내부 arrow 중심 위치
        let arrowCenterInTooltip: CGFloat
        switch tooltipPosition {
        case .topLeading, .bottomLeading:
            arrowCenterInTooltip = arrowInset

        case .topTrailing, .bottomTrailing:
            arrowCenterInTooltip = tooltipSize.width - arrowInset
        }

        /// arrow 중심 = 버튼 중심
        let x = anchorCenterX - arrowCenterInTooltip

        let y: CGFloat
        switch tooltipPosition {
        case .topLeading, .topTrailing:
            y = frame.minY - tooltipSize.height - 8
        case .bottomLeading, .bottomTrailing:
            y = frame.maxY + 8
        }

        tooltip.frame = CGRect(
            x: x,
            y: y,
            width: tooltipSize.width,
            height: tooltipSize.height
        )

        tooltip.alpha = 0
        UIView.animate(withDuration: 0.25) {
            tooltip.alpha = 1
        }
    }
    
    /// 툴팁 제거
    static func dismiss() {
        currentTooltip?.removeFromSuperview()
        currentTooltip = nil

        overlayView?.removeFromSuperview()
        overlayView = nil
    }
}
