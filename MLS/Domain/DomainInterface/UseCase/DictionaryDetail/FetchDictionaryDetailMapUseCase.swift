import RxSwift

public protocol FetchDictionaryDetailMapUseCase {
    func execute(id: Int) -> Observable<DictionaryDetailMapResponse>
}
