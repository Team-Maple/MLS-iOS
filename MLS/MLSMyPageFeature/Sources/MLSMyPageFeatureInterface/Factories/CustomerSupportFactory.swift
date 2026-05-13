import MLSCore

public protocol CustomerSupportFactory {
    func make(type: CustomerSupportType) -> BaseViewController
}
