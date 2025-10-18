import RxSwift

public protocol FetchDictionaryDetailNpcUseCase {
    func execute(id: Int) -> Observable<DictionaryDetailNpcResponse>
}
