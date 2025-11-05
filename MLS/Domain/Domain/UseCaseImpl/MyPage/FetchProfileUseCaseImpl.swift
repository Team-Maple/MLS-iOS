import DomainInterface

import RxSwift

public class FetchProfileUseCaseImpl: FetchProfileUseCase {
    private var repository: AuthAPIRepository
    private let fetchJobUseCase: FetchJobUseCase

    public init(repository: AuthAPIRepository, fetchJobUseCase: FetchJobUseCase) {
        self.repository = repository
        self.fetchJobUseCase = fetchJobUseCase
    }

    public func execute() -> Observable<MyPageResponse?> {
        return repository.fetchProfile()
            .flatMap { [weak self] profile -> Observable<MyPageResponse?> in
                guard let self = self, let jobId = profile?.jobId else {
                    return .just(profile)
                }

                return self.fetchJobUseCase.execute(jobId: String(jobId))
                    .map { job in
                        var new = profile
                        new?.jobName = job.name
                        return new
                    }
            }
    }
}
