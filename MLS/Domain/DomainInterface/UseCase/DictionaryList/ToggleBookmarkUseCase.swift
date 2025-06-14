import RxSwift

public protocol ToggleBookmarkUseCase {
    func execute(id: String) -> Observable<[DictionaryItem]>
}
