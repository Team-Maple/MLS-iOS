import Foundation


import RxSwift

public class UpdateUserInfoUseCaseImpl: UpdateUserInfoUseCase {
    private let repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(level: Int, selectedJobID: Int) -> Completable {
        return repository.updateUserInfo(level: level, selectedJobID: selectedJobID)
    }
}
