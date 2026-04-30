import MLSMyPageFeatureInterface

import RxSwift

public class FetchProfileUseCaseImpl: FetchProfileUseCase {
    private var repository: MyPageRepository

    public init(repository: MyPageRepository) {
        self.repository = repository
    }

    public func execute() -> Observable<MyPageResponse?> {
        return repository.fetchProfile()
            .flatMap { [weak self] profile -> Observable<MyPageResponse?> in
                guard let self = self, let jobId = profile?.jobId else {
                    return .just(profile)
                }

                return repository.fetchJob(jobId: String(jobId))
                    .map { job in
                        var new = profile
                        new?.jobName = job.name
                        return new
                    }
            }
    }
}
