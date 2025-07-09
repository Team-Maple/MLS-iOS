import Foundation

import DomainInterface

public final class BookmarkOnBoardingRepositoryImpl: UserDefaultsRespository {
    public init() {}
    
    private enum Key {
        static let hasSeenBookmark = "bookmarkOnboarding"
    }
    
    public func getBookmarkOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: Key.hasSeenBookmark)
    }
    
    public func setBookmarkOnBoarding() {
        UserDefaults.standard.set(true, forKey: Key.hasSeenBookmark)
    }
}
