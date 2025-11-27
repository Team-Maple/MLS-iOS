import RxSwift

public protocol SetCollectionUseCase {
    func execute(collectionId: Int, name: String) -> Completable
}
