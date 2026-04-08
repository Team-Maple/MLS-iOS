import Foundation


import RxSwift

public class FetchJobListUseCaseImpl: FetchJobListUseCase {
    private let repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute() -> Observable<JobListResponse> {
        return repository.fetchJobList()
    }
}
