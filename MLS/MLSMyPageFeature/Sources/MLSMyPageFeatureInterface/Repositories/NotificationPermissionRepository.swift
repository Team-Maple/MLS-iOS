import RxSwift

public protocol NotificationPermissionRepository {
    func fetchAuthorizationStatus() -> Single<Bool>
}
