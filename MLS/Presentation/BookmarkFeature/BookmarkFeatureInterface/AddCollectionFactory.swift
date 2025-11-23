import BaseFeature
import DomainInterface

public protocol AddCollectionFactory {
    func make(collection: CollectionResponse?, onDismissWithMessage: @escaping (CollectionResponse?) -> Void) -> BaseViewController
}
