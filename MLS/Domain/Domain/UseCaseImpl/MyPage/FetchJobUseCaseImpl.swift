import DomainInterface

import RxSwift

public class FetchJobUseCaseImpl: FetchJobUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(jobId: String) -> Observable<Job> {
        repository.fetchJob(jobId: jobId)
    }
}
