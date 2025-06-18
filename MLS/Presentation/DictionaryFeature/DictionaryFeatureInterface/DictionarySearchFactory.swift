import BaseFeature
import DomainInterface

public protocol DictionarySearchFactory {
    func make() -> BaseViewController
}
