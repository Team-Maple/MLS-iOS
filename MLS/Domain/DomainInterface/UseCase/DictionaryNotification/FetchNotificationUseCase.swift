import RxSwift

public protocol FetchNotificationUseCase {
    func execute() -> Observable<[Notification]>
}
