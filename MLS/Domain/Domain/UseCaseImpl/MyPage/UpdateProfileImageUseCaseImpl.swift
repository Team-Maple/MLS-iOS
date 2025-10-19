import DomainInterface

import RxSwift

public class UpdateProfileImageUseCaseImpl: UpdateProfileImageUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(url: String) -> Completable {
        return repository.updateProfileImage(url: url)
    }
}
