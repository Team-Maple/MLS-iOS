import UIKit

public protocol ModalPresentable {
    var modalHeight: CGFloat? { get }
    var modalStyle: ModalStyle { get }
}

public enum ModalStyle {
    case bottomSheet
    case modal
}

// 모달 구성 관련 상수 정의
internal enum ModalConfig {
    static let containerCornerRadius: CGFloat = 20
    static let containerTransformY: CGFloat = 400
    static let containerBottomInset: CGFloat = 2
    static let containerHorizontalInset: CGFloat = 8
    static let containerVerticalContentInset: CGFloat = 16
    static let bottomSheetStyleBottomInset: CGFloat = 34

    static let gestureBarTopInset: CGFloat = 12
    static let gestureBarWidth: CGFloat = 60
    static let gestureBarHeight: CGFloat = 4
}
