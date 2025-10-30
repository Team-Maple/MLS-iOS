import RxSwift

public protocol UserDefaultsRepository {
    func fetchRecentSearch() -> Observable<[String]>
    func addRecentSearch(keyword: String) -> Completable
    func removeRecentSearch(keyword: String) -> Completable
}
