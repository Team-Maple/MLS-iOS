import RxSwift

public protocol FetchDictionaryQuestListUseCase {
    /// 어떤 타입인지에 따라서 쿼리가 결정됨 -> 타입 마다 쿼리가 댜름.
    func execute(keyword: String, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse>
}
