import RxSwift

public protocol RecentSearchAddUseCase {
    func add(keyword: String) -> Completable
}
