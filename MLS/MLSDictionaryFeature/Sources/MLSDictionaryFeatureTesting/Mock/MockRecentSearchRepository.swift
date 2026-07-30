import MLSDictionaryFeatureInterface

import RxSwift

final public class MockRecentSearchRepository: RecentSearchRepository {
    private var searches: [String]

    public init(searches: [String] = ["사과", "바나나", "포션"]) {
        self.searches = searches
    }

    public func fetchRecentSearch() -> Observable<[String]> {
        return .just(searches)
    }

    public func addRecentSearch(keyword: String) -> Completable {
        searches.insert(keyword, at: 0)
        return .empty()
    }

    public func removeRecentSearch(keyword: String) -> Completable {
        searches.removeAll { $0 == keyword }
        return .empty()
    }

    public func removeAllSearch() -> Completable {
        searches.removeAll()
        return .empty()
    }
}
