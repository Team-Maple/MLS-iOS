import DomainInterface

public final class SetBookmarkOnBoardingUseCaseImpl: SetBookmarkOnBoardingUseCase {
    private let repository: UserDefaultsRespository

    public init(repository: UserDefaultsRespository) {
        self.repository = repository
    }

    public func execute() {
        return repository.setBookmarkOnBoarding()
    }
}
