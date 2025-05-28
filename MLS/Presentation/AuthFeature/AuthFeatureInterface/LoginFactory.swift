import BaseFeature
import DomainInterface

public protocol LoginFactory {
    func make(
        isReLogin: Bool
    ) -> BaseViewController
}
