import RxSwift

public protocol DictionaryUserDefaultsRepository {
    func fetchDictionaryDetail() -> Observable<Bool>
    func saveDictionaryDetail() -> Completable
    func checkFirstLaunchRecommendation() -> Observable<Bool>
}
