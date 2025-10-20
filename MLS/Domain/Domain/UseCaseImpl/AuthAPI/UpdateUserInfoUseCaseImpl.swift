import Foundation

import DomainInterface

import RxSwift

public class UpdateUserInfoUseCaseImpl: UpdateUserInfoUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(level: Int, selectedJobID: Int) -> Completable {
        return repository.updateUserInfo(level: level, selectedJobID: selectedJobID)
    }
}
