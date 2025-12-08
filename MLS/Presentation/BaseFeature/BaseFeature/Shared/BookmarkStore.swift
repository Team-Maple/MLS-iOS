//import RxSwift
//import RxCocoa
//
//public final class BookmarkStore {
//    public static let shared = BookmarkStore()
//
//    private let disposeBag = DisposeBag()
//
//    // BehaviorRelay 사용
//    private let bookmarksRelay = BehaviorRelay<[Int: Bool]>(value: [:])
//
//    // 외부에서 Observable로 구독 가능
//    public var bookmarks: Observable<[Int: Bool]> {
//        return bookmarksRelay.asObservable()
//    }
//
//    private init() {}
//
//    public func setBookmark(id: Int, isBookmarked: Bool) {
//        var current = bookmarksRelay.value
//        current[id] = isBookmarked
//        bookmarksRelay.accept(current)
//    }
//
//    public func isBookmarked(id: Int) -> Bool {
//        return bookmarksRelay.value[id] ?? false
//    }
//}
