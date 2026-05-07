import MLSMyPageFeatureInterface

import RxSwift

public final class MockAlarmRepository: AlarmRepository {

    public init() {}

    public func fetchPatchNotes(cursor: Int?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        .just(makePagedAlarmResponse(prefix: "패치노트", cursor: cursor, pageSize: pageSize))
    }

    public func fetchNotices(cursor: Int?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        .just(makePagedAlarmResponse(prefix: "공지사항", cursor: cursor, pageSize: pageSize))
    }

    public func fetchOutdatedEvents(cursor: Int?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        .just(makePagedAlarmResponse(prefix: "종료 이벤트", cursor: cursor, pageSize: pageSize))
    }

    public func fetchOngoingEvents(cursor: Int?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        .just(makePagedAlarmResponse(prefix: "진행중 이벤트", cursor: cursor, pageSize: pageSize))
    }

    public func fetchAll(cursor: Int?, pageSize: Int) -> Observable<PagedEntity<AllAlarmResponse>> {
        let startID = cursor ?? 200

        let items = (0..<pageSize).map { index in
            let id = startID - index

            return AllAlarmResponse(
                id: id,
                type: "notice",
                title: "전체 알람 \(id)",
                link: "https://example.com/\(id)",
                date: "2026-04-26",
                alreadyRead: false
            )
        }

        return .just(
            PagedEntity(
                items: items,
                hasMore: startID > pageSize
            )
        )
    }

    public func setRead(alarmLink: String) -> Completable {
        .empty()
    }
}

// MARK: - Private
private extension MockAlarmRepository {

    func makePagedAlarmResponse(
        prefix: String,
        cursor: Int?,
        pageSize: Int
    ) -> PagedEntity<AlarmResponse> {

        let startID = cursor ?? 1000

        let items = (0..<pageSize).map { index in
            let id = startID - index

            return AlarmResponse(
                id: id,
                type: "event",
                title: "\(prefix) \(id)",
                link: "https://example.com/\(id)",
                date: "2026-04-26"
            )
        }

        return PagedEntity(
            items: items,
            hasMore: startID > pageSize
        )
    }
}
