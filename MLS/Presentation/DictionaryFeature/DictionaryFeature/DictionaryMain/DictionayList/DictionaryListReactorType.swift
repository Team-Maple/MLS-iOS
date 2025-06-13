import ReactorKit
import RxSwift
import UIKit

public protocol DictionaryListReactorType: Reactor where State: DictionaryStateType {
    var currentState: State { get }
    var initialState: State { get }
}

public protocol DictionaryStateType {
    var items: [DictionaryItem] { get }
    var type: DictionaryType { get }
}
