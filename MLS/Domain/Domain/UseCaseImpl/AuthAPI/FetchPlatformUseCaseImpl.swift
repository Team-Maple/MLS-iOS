import Foundation

import DomainInterface

import RxSwift

public class FetchPlatformUseCaseImpl: FetchPlatformUseCase {
    private var repository: UserDefaultsRepository

    public init(repository: UserDefaultsRepository) {
        self.repository = repository
    }

    public func execute() -> Observable<LoginPlatform?> {
        return repository.fetchPlatform()
    }
}
