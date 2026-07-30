import UIKit

import MLSAuthFeatureInterface
import MLSBookmarkFeatureInterface
import MLSCore
import MLSDesignSystem
import MLSDictionaryFeatureInterface

import RxRelay

// MARK: - Stub Modal ViewController

public final class StubModalViewController: BaseViewController, ModalPresentable {
    public var modalHeight: CGFloat?
}

// MARK: - Login

public final class StubLoginFactory: LoginFactory {
    public init() {}
    public func make(exitRoute: LoginExitRoute, onLoginCompleted: (() -> Void)?) -> BaseViewController {
        BaseViewController()
    }
}

// MARK: - Dictionary External Factories

public final class StubDictionarySearchFactory: DictionarySearchFactory {
    public init() {}
    public func make() -> BaseViewController { BaseViewController() }
}

public final class StubDictionaryNotificationFactory: DictionaryNotificationFactory {
    public init() {}
    public func make() -> BaseViewController { BaseViewController() }
}

public final class StubDictionaryDetailFactory: DictionaryDetailFactory {
    public init() {}
    public func make(
        type: DictionaryType,
        id: Int,
        bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?,
        loginRelay: PublishRelay<Void>?
    ) -> BaseViewController {
        BaseViewController()
    }
}

public final class StubSortedBottomSheetFactory: SortedBottomSheetFactory {
    public init() {}
    public func make(
        sortedOptions: [SortType],
        selectedIndex: Int,
        onSelectedIndex: @escaping (Int) -> Void
    ) -> BaseViewController & ModalPresentable {
        StubModalViewController()
    }
}

public final class StubItemFilterBottomSheetFactory: ItemFilterBottomSheetFactory {
    public init() {}
    public func make(onFilterSelected: @escaping ([(String, String)]) -> Void) -> BaseViewController {
        BaseViewController()
    }
}

public final class StubMonsterFilterBottomSheetFactory: MonsterFilterBottomSheetFactory {
    public init() {}
    public func make(
        startLevel: Int,
        endLevel: Int,
        onFilterSelected: @escaping (Int, Int) -> Void
    ) -> BaseViewController & ModalPresentable {
        StubModalViewController()
    }
}
