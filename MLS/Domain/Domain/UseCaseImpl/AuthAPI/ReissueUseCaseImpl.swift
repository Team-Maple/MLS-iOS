import Foundation

import DomainInterface

import RxSwift

public class ReissueUseCaseImpl: ReissueUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(refreshToken: String) -> Observable<LoginResponse> {
        return repository.reissueToken(refreshToken: refreshToken)
    }
}
