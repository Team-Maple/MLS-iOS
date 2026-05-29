import MLSCore
import MLSDesignSystem
import RxRelay

// DictionaryFeature 모듈이 SPM으로 전환되기 전까지 임시로 정의하는 프로토콜들입니다.
// MLSDictionaryFeature 모듈이 생성되면 해당 모듈의 타입을 사용하도록 교체해야 합니다.

public protocol DictionarySearchFactory {
    func make() -> BaseViewController
}

public protocol DictionaryNotificationFactory {
    func make() -> BaseViewController
}

public protocol DictionaryDetailFactory {
    func make(
        type: DictionaryType,
        id: Int,
        bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?,
        loginRelay: PublishRelay<Void>?
    ) -> BaseViewController
}

public protocol SortedBottomSheetFactory {
    func make(
        sortedOptions: [SortType],
        selectedIndex: Int,
        onSelectedIndex: @escaping (Int) -> Void
    ) -> BaseViewController & ModalPresentable
}

public protocol ItemFilterBottomSheetFactory {
    func make(onFilterSelected: @escaping ([(String, String)]) -> Void) -> BaseViewController
}

public protocol MonsterFilterBottomSheetFactory {
    func make(
        startLevel: Int,
        endLevel: Int,
        onFilterSelected: @escaping (Int, Int) -> Void
    ) -> BaseViewController & ModalPresentable
}
