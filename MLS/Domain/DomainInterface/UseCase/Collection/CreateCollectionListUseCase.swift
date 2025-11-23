import RxSwift

public protocol CreateCollectionListUseCase {
    func execute(name: String) -> Completable
}
