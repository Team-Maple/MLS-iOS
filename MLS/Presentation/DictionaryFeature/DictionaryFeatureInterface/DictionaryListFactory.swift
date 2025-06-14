import BaseFeature
import DomainInterface

public protocol DictionaryListFactory {
    func make(type: DictionaryType) -> BaseViewController
}
