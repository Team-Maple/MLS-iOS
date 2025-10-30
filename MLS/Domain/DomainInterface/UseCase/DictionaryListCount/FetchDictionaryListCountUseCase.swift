import RxSwift

public protocol FetchDictionaryListCountUseCase {
    func execute(type: String, keyword: String?) -> Observable<SearchCountResponse>
}
