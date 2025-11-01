import RxSwift

public protocol FetchDictionarySearchListUseCase {
    func execute(keyword: String) -> Observable<DictionaryMainResponse>
}
