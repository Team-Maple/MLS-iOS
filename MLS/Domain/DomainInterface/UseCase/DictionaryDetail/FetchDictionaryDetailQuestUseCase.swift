import RxSwift

public protocol FetchDictionaryDetailQuestUseCase {
    func execute(id: Int) -> Observable<DictionaryDetailQuestResponse>
}
