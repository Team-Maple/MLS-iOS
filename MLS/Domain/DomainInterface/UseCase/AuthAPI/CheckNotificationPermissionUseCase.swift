import RxSwift

public protocol CheckNotificationPermissionUseCase {
    func execute() -> Single<Bool>
}
