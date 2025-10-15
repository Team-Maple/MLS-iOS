import Foundation

import RxSwift

public protocol AlarmAPIRepository {
    func fetchPatchNotes(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>

    func fetchNotices(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>

    func fetchOutdatedEvents(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>

    func fetchOngoingEvents(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>

    func fetchAll(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AllAlarmResponse>>

    func setRead(alarmLink: String) -> Completable
}
