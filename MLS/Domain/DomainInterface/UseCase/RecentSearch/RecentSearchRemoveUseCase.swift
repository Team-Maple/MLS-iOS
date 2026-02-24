import RxSwift

public protocol RecentSearchRemoveUseCase {
    func remove(keyword: String) -> Completable
    func removeAll() -> Completable
}
