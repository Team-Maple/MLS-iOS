import RxSwift

public protocol FetchDictionaryDetailQuestLinkedQuestsUseCase {
    func execute(id: Int) -> Observable<DictionaryDetailQuestLinkedQuestsResponse>
}
