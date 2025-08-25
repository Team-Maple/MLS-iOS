import Foundation

import DomainInterface

import RxSwift

public class FetchJobListUseCaseImpl: FetchJobListUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute() -> Observable<JobListResponse> {
        return repository.fetchJobList()
    }
}
