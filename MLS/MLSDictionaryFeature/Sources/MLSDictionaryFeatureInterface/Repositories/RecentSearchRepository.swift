import RxSwift

public protocol RecentSearchRepository {
    func fetchRecentSearch() -> Observable<[String]>
    func addRecentSearch(keyword: String) -> Completable
    func removeRecentSearch(keyword: String) -> Completable
    func removeAllSearch() -> Completable
}
