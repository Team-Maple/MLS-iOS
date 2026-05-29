import MLSBookmarkFeatureInterface
import RxSwift

public final class MockCollectionRepository: CollectionRepository {
    public var fetchCollectionListResult: Observable<[CollectionResponse]> = .just([])
    public var createCollectionListResult: Completable = .empty()
    public var fetchCollectionResult: Observable<[BookmarkResponse]> = .just([])
    public var updateCollectionNameResult: Completable = .empty()
    public var deleteCollectionResult: Completable = .empty()
    public var addCollectionAndBookmarkResult: Completable = .empty()

    public init() {}

    public func fetchCollectionList(sort: String?) -> Observable<[CollectionResponse]> {
        fetchCollectionListResult
    }

    public func createCollectionList(name: String) -> Completable {
        createCollectionListResult
    }

    public func fetchCollection(id: Int) -> Observable<[BookmarkResponse]> {
        fetchCollectionResult
    }

    public func updateCollectionName(collectionId: Int, name: String) -> Completable {
        updateCollectionNameResult
    }

    public func deleteCollection(collectionId: Int) -> Completable {
        deleteCollectionResult
    }

    public func addCollectionAndBookmark(collectionIds: [Int], bookmarkIds: [Int]) -> Completable {
        addCollectionAndBookmarkResult
    }
}
