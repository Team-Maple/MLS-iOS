import RxSwift

public protocol FetchDictionaryDetailMapNpcUseCase {
    func execute(id: Int) -> Observable<[DictionaryDetailMapNpcResponse]>
}
