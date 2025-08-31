import BaseFeature
import DomainInterface

public protocol DictionaryDetailFactory {
    func make(type: DictionaryType) -> BaseViewController
}
