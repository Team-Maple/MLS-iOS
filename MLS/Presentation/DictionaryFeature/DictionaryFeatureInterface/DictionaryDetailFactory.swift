import BaseFeature
import DomainInterface

public protocol DictionaryDetailFactory {
    func make() -> BaseViewController
}
