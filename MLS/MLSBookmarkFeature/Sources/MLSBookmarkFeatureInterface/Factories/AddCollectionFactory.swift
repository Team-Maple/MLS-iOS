import MLSCore

public protocol AddCollectionFactory {
    func make(collection: CollectionResponse?) -> BaseViewController
}
