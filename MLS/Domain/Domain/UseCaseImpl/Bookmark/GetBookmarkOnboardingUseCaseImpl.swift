import DomainInterface

public final class GetBookmarkOnboardingUseCaseImpl: GetBookmarkOnboardingUseCase {
    private let repository: UserDefaultsRespository

    public init(repository: UserDefaultsRespository) {
        self.repository = repository
    }

    public func execute() -> Bool {
        return repository.getBookmarkOnboarding()
    }
}
