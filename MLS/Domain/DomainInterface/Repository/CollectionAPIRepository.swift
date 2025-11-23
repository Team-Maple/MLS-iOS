import Foundation

import RxSwift

public protocol CollectionAPIRepository {
    // 컬렉션 목록 조회 
    func fetchCollectionList() -> Observable<[CollectionListResponse]>
    // 컬렉션 목록 추가
    func createCollectionList(name: String) -> Completable
}
