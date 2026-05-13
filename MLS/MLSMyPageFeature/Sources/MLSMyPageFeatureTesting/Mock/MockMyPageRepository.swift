import MLSAuthFeatureInterface
import MLSMyPageFeatureInterface

import RxSwift

public final class MockMyPageRepository: MyPageRepository {

    public init() {}

    public var fetchProfileResult: Observable<MyPageResponse?> = .just(nil)
    public var fetchJobResult: Observable<Job> = .just(.init(name: "", id: 0))
    public var updateNickNameResult: Observable<MyPageResponse> =
        .just(.init(nickname: "", jobId: nil, jobName: "", level: nil, profileUrl: "", platform: .apple, noticeAgreement: nil, patchNoteAgreement: nil, eventAgreement: nil))
    public var updateProfileImageResult: Completable = .empty()

    public private(set) var fetchJobCalled = false
    public private(set) var receivedJobId: String?

    public func fetchProfile() -> Observable<MyPageResponse?> {
        fetchProfileResult
    }

    public func fetchJob(jobId: String) -> Observable<Job> {
        fetchJobCalled = true
        receivedJobId = jobId
        return fetchJobResult
    }

    public func updateNickName(nickName: String) -> Observable<MyPageResponse> {
        updateNickNameResult
    }

    public func updateProfileImage(url: String) -> Completable {
        updateProfileImageResult
    }
}
