import RxSwift

public protocol FetchDictionaryDetailNpcQuestUseCase {
    func execute(id: Int, sort: String?) -> Observable<[DictionaryDetailNpcQuestResponse]>
}
