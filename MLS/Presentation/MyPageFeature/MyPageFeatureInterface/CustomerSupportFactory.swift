import BaseFeature
import DomainInterface

public protocol CustomerSupportFactory {
    func make(type: CustomerSupportType) -> BaseViewController
}
