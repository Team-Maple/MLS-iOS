import DomainInterface

import RxSwift

public class FetchNotificationUseCaseImpl: FetchNotificationUseCase {
    public init() {}

    public func execute() -> Observable<[Notification]> {
        return Observable.just([
            Notification(title: "신규 업데이트 알림", date: "2025년 1월 1일"),
            Notification(title: "신규 업데이트 알림", date: "2025년 2월 1일", isChecked: true),
            Notification(title: "신규 업데이트 알림", date: "2025년 3월 1일"),
            Notification(title: "신규 업데이트 알림", date: "2025년 4월 1일"),
            Notification(title: "신규 업데이트 알림", date: "2025년 5월 1일", isChecked: true),
            Notification(title: "신규 업데이트 알림", date: "2025년 6월 1일"),
            Notification(title: "신규 업데이트 알림", date: "2025년 7월 1일")
        ])
    }
}
