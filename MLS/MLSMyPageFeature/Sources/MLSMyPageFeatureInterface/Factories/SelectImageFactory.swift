import MLSCore
import MLSDesignSystem

public protocol SelectImageFactory {
    func make() -> BaseViewController & ModalPresentable
}
