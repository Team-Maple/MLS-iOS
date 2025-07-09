import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

public final class BookmarkMainFactoryImpl: BookmarkMainFactory {
    private let getOnBoardingUseCase: GetBookmarkOnboardingUseCase
    private let setOnBoardingUseCase: SetBookmarkOnBoardingUseCase
    private let onBoardingFactory: BookmarkOnBoardingFactory
    
    public init(
        getOnBoardingUseCase: GetBookmarkOnboardingUseCase,
        setOnBoardingUseCase: SetBookmarkOnBoardingUseCase,
        onBoardingFactory: BookmarkOnBoardingFactory
    ) {
        self.getOnBoardingUseCase = getOnBoardingUseCase
        self.setOnBoardingUseCase = setOnBoardingUseCase
        self.onBoardingFactory = onBoardingFactory
    }

    public func make() -> BaseViewController {
        let reactor = BookmarkMainReactor(getOnBoardingUseCase: getOnBoardingUseCase, setOnBoardingUseCase: setOnBoardingUseCase)
        let viewController = BookmarkMainViewController(onBoardingFactory: onBoardingFactory)
        viewController.reactor = reactor
        return viewController
    }
}
