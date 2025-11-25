import BaseFeature
import DomainInterface

public protocol BookmarkModalFactory {
    func make(bookmarkId: Int, onDismissWithColletions: (([CollectionResponse?]) -> Void)?, onDismissWithMessage: ((CollectionResponse?) -> Void)?) -> BaseViewController
}
