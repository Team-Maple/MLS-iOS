import Foundation

import RxSwift

public protocol AlarmAPIRepository {
    func fetchPatchNotes(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>

    func fetchNotices(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>

    func fetchOutdatedEvents(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>

    func fetchOngoingEvents(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>

    func fetchAll(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AllAlarmResponse>>

    func setRead(alarmLink: String) -> Completable
}
