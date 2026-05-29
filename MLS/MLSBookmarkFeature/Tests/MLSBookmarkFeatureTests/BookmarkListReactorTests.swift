@testable import MLSBookmarkFeature
import MLSBookmarkFeatureInterface
import MLSBookmarkFeatureTesting
import RxBlocking
import XCTest

final class BookmarkListReactorTests: XCTestCase {
    var authRepository: MockBookmarkAuthRepository!
    var bookmarkRepository: MockBookmarkRepository!
    var parseUseCase: MockParseItemFilterResultUseCase!

    override func setUp() {
        super.setUp()
        authRepository = MockBookmarkAuthRepository()
        bookmarkRepository = MockBookmarkRepository()
        parseUseCase = MockParseItemFilterResultUseCase()
    }

    func test_viewWillAppear_whenLoggedIn_fetchesItems() throws {
        let expectedItems = [
            BookmarkResponse(name: "테스트", bookmarkId: 1, originalId: 100, imageUrl: nil, type: .item, level: nil)
        ]
        authRepository.isLoggedInResult = .just(true)
        bookmarkRepository.fetchBookmarkResult = .just(expectedItems)

        let reactor = BookmarkListReactor(
            type: .total,
            authRepository: authRepository,
            bookmarkRepository: bookmarkRepository,
            parseItemFilterResultUseCase: parseUseCase
        )

        reactor.action.onNext(.viewWillAppear)

        let items = try reactor.state.map(\.items).toBlocking(timeout: 1).first()
        XCTAssertEqual(items, expectedItems)
    }

    func test_viewWillAppear_whenLoggedOut_itemsEmpty() throws {
        authRepository.isLoggedInResult = .just(false)

        let reactor = BookmarkListReactor(
            type: .total,
            authRepository: authRepository,
            bookmarkRepository: bookmarkRepository,
            parseItemFilterResultUseCase: parseUseCase
        )

        reactor.action.onNext(.viewWillAppear)

        let isLogin = try reactor.state.map(\.isLogin).toBlocking(timeout: 1).first()
        XCTAssertEqual(isLogin, false)
        XCTAssertTrue(reactor.currentState.items.isEmpty)
    }

    func test_toggleBookmark_removesItemAndEmitsDeleteEvent() throws {
        let item = BookmarkResponse(name: "테스트", bookmarkId: 1, originalId: 100, imageUrl: nil, type: .item, level: nil)
        authRepository.isLoggedInResult = .just(true)
        bookmarkRepository.fetchBookmarkResult = .just([item])
        bookmarkRepository.deleteBookmarkResult = .empty()

        let reactor = BookmarkListReactor(
            type: .total,
            authRepository: authRepository,
            bookmarkRepository: bookmarkRepository,
            parseItemFilterResultUseCase: parseUseCase
        )

        reactor.action.onNext(.viewWillAppear)
        reactor.action.onNext(.toggleBookmark(100))

        let event = try reactor.state.map(\.uiEvent).toBlocking(timeout: 1).first()
        if case .delete(let deletedItem) = event {
            XCTAssertEqual(deletedItem.originalId, 100)
        } else {
            XCTFail("Expected delete event")
        }
    }
}
