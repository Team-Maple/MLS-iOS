import BaseFeature
import DomainInterface

import RxCocoa

public protocol DictionaryDetailFactory {
    func make(type: DictionaryType, id: Int, bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?, loginRelay: PublishRelay<Void>?) -> BaseViewController
}
