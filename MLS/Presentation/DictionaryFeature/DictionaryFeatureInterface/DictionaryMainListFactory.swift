import BaseFeature
import DomainInterface

public protocol DictionaryMainListFactory {
    func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController
}

// MARK: - Enum
public enum DictionaryMainViewType {
    case main
    case search
}
