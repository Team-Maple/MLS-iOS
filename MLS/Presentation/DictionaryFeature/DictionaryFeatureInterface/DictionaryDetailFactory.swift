import BaseFeature
import DomainInterface

import RxCocoa

public protocol DictionaryDetailFactory {
    func make(type: DictionaryType, id: Int, bookmarkRelay: PublishRelay<(Int, Bool)>?) -> BaseViewController
}
