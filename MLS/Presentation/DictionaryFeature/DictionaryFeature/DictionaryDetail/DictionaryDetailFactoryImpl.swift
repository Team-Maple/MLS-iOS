import BaseFeature
import DictionaryFeatureInterface

public final class DictionaryDetailFactoryImpl: DictionaryDetailFactory {
    public init() {}

    public func make() -> BaseViewController {
        let reactor = DictionaryDetailReactor()
        // 임시 이니셜라이저 - 추후 수정 예정
        let viewController = DictionaryDetailViewController(text: "")
        viewController.reactor = reactor
        // 진입 시 탭바 히든처리
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
