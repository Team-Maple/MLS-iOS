import MLSCore

public protocol CollectionDetailFactory {
    func make(collection: CollectionResponse, onMoveToMain: (() -> Void)?) -> BaseViewController
}
