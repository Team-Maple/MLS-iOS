import RxSwift

public protocol FetchDictionaryMonsterListUseCase {
    /// 어떤 타입인지에 따라서 쿼리가 결정됨 -> 타입 마다 쿼리가 댜름.
    func execute(type: DictionaryType, query: DictionaryListQuery) -> Observable<DictionaryMainResponse>
}
