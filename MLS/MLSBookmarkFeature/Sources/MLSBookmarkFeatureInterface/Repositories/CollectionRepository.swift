import RxSwift

public protocol CollectionRepository {
    func fetchCollectionList(sort: String?) -> Observable<[CollectionResponse]>
    func createCollectionList(name: String) -> Completable
    func fetchCollection(id: Int) -> Observable<[BookmarkResponse]>
    func updateCollectionName(collectionId: Int, name: String) -> Completable
    func deleteCollection(collectionId: Int) -> Completable
    func addCollectionAndBookmark(collectionIds: [Int], bookmarkIds: [Int]) -> Completable
}
