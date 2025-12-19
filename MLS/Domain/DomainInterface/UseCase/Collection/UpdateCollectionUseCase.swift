import RxSwift

public protocol UpdateCollectionUseCase {
    func execute(collectionId: Int, name: String) -> Completable
}
