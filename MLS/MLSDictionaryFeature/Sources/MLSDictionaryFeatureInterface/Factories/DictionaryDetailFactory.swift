import MLSCore

import RxCocoa

public protocol DictionaryDetailFactory: AnyObject {
    func make(type: DictionaryType, id: Int, bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?, loginRelay: PublishRelay<Void>?) -> BaseViewController
}
