import RxSwift

public protocol UserDefaultsRepository {
    func fetchDictionaryDetail() -> Observable<Bool>
    func saveDictionaryDetail() -> Completable
}
