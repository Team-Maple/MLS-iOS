import UIKit

public protocol ModalPresentable {
    var modalHeight: CGFloat? { get }
    var modalStyle: ModalStyle { get }
}

public enum ModalStyle {
    case bottomSheet
    case modal
    case alert

    var containerCornerRadius: CGFloat {
        switch self {
        case .bottomSheet, .modal:
            return 20
        case .alert:
            return 24
        }
    }
}

// 모달 구성 관련 상수 정의
internal enum ModalConfig {
    static let containerTransformY: CGFloat = 400
    static let containerBottomInset: CGFloat = 8
    static let containerHorizontalInset: CGFloat = 8
    static let containerVerticalContentInset: CGFloat = 16
    static let bottomSheetStyleBottomInset: CGFloat = 34
    static let bottomSheetStyleHorizontalInset: CGFloat = 20
    static let alertSheetStyleInset: CGFloat = 20

    static let gestureBarTopInset: CGFloat = 12
    static let gestureBarWidth: CGFloat = 60
    static let gestureBarHeight: CGFloat = 4
}
