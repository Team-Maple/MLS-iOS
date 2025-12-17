import Foundation

import RxSwift

public protocol CollectionAPIRepository {
    // 컬렉션 목록 조회 
    func fetchCollectionList(sort: String?) -> Observable<[CollectionResponse]>
    // 컬렉션 목록 추가
    func createCollectionList(name: String) -> Completable
    // 컬렉션 상세 조회
    func fetchCollectionUseCase(id: Int) -> Observable<[BookmarkResponse]>

    func updateCollectionName(collectionId: Int, name: String) -> Completable

    func deleteCollection(collectionId: Int) -> Completable

    func addCollectionAndBookmark(collectionIds: [Int], bookmarkIds: [Int]) -> Completable
}
