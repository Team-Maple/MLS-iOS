import RxSwift

public protocol DeleteCollectionUseCase {
    func execute(collectionId: Int) -> Completable
}
