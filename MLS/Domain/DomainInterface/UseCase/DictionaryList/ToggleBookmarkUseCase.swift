import RxSwift

public protocol ToggleBookmarkUseCase {
    func execute(id: String, type: DictionaryType) -> Observable<[DictionaryItem]>
}
