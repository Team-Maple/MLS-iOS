import MLSAuthFeatureInterface

import RxSwift

public protocol MyPageRepository {
    func fetchProfile() -> Observable<MyPageResponse?>
    func fetchJob(jobId: String) -> Observable<Job>
    func updateNickName(nickName: String) -> Observable<MyPageResponse>
    func updateProfileImage(url: String) -> Completable
}
