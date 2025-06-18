import BaseFeature
import DomainInterface

public protocol DictionaryMainViewFactory {
    func make() -> BaseViewController
}
