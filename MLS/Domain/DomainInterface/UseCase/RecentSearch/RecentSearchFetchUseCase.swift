import RxSwift

public protocol RecentSearchFetchUseCase {
    func fetch() -> Observable<[String]>
}
