import BaseFeature
import DomainInterface

public protocol BookmarkModalFactory {
    func make(onDismissWithColletions: (([CollectionResponse?]) -> Void)?, onDismissWithMessage: ((CollectionResponse?) -> Void)?) -> BaseViewController
}
