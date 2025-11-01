import RxSwift

public protocol FetchDictionaryAllListUseCase {
    // 쿼리없이 keyword, page만 전달
    func execute(keyword: String?, page: Int?) -> Observable<DictionaryMainResponse>
}
