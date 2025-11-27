import BaseFeature
import DomainInterface

public protocol AddCollectionFactory {
    func make(collection: CollectionResponse?) -> BaseViewController
}
