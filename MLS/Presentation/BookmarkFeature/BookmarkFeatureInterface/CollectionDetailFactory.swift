import BaseFeature
import DomainInterface

public protocol CollectionDetailFactory {
    func make(collection: CollectionResponse, onMoveToMain: (() -> Void)?) -> BaseViewController
}
