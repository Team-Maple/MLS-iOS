import RxSwift

public protocol UserDefaultsRepository {
    func fetchRecentSearch() -> Observable<[String]>
    func addRecentSearch(keyword: String) -> Completable
    func removeRecentSearch(keyword: String) -> Completable

    func fetchPlatform() -> Observable<LoginPlatform?>
    func savePlatform(platform: LoginPlatform) -> Completable

    func fetchBookmark() -> Observable<Bool>
    func saveBookmark() -> Completable

    func fetchDictionaryDetail() -> Observable<Bool>
    func saveDictionaryDetail() -> Completable
}
