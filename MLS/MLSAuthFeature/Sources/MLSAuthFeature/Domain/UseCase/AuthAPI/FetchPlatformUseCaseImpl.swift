import Foundation


import RxSwift

public class FetchPlatformUseCaseImpl: FetchPlatformUseCase {
    private let repository: UserDefaultsRepository

    public init(repository: UserDefaultsRepository) {
        self.repository = repository
    }

    public func execute() -> Observable<LoginPlatform?> {
        return repository.fetchPlatform()
    }
}
