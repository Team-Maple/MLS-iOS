import RxSwift

public protocol AddCollectionAndBookmarkUseCase {
    func execute(collectionIds: [Int], bookmarkIds: [Int]) -> Completable
}
