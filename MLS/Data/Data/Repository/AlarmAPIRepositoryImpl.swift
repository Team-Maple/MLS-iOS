import Foundation

import DomainInterface

import RxSwift

public class AlarmAPIRepositoryImpl: AlarmAPIRepository {
    private let provider: NetworkProvider
    private let tokenInterceptor: Interceptor

    public init(provider: NetworkProvider, interceptor: Interceptor) {
        self.provider = provider
        self.tokenInterceptor = interceptor
    }

    public func fetchPatchNotes(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        let endpoint = AlarmEndPoint.fetchPatchNotes(query: AlarmQuery(cursor: cursor, pageSize: pageSize))
        return provider.requestData(endPoint: endpoint, interceptor: tokenInterceptor)
            .map { $0.toAlarmDomain() }
    }

    public func fetchNotices(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        let endpoint = AlarmEndPoint.fetchNotices(query: AlarmQuery(cursor: cursor, pageSize: pageSize))
        return provider.requestData(endPoint: endpoint, interceptor: tokenInterceptor)
            .map { $0.toAlarmDomain() }
    }

    public func fetchOutdatedEvents(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        let endpoint = AlarmEndPoint.fetchOutdatedEvents(query: AlarmQuery(cursor: cursor, pageSize: pageSize))
        return provider.requestData(endPoint: endpoint, interceptor: tokenInterceptor)
            .map { $0.toAlarmDomain() }
    }

    public func fetchOngoingEvents(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        let endpoint = AlarmEndPoint.fetchOngoingEvents(query: AlarmQuery(cursor: cursor, pageSize: pageSize))
        return provider.requestData(endPoint: endpoint, interceptor: tokenInterceptor)
            .map { $0.toAlarmDomain() }
    }

    public func fetchAll(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AllAlarmResponse>> {
        let endpoint = AlarmEndPoint.fetchAll(query: AlarmQuery(cursor: cursor, pageSize: pageSize))
        return provider.requestData(endPoint: endpoint, interceptor: tokenInterceptor)
            .map { $0.toAllAlarmDomain() }
    }

    public func setRead(alarmLink: String) -> Completable {
        let endpoint = AlarmEndPoint.setRead(query: SetReadQuery(alrimLink: alarmLink))
        return provider.requestData(endPoint: endpoint, interceptor: tokenInterceptor)
    }

}

private extension AlarmAPIRepositoryImpl {
    struct AlarmQuery: Encodable {
        let cursor: String?
        let pageSize: Int
    }

    struct SetReadQuery: Encodable {
        let alrimLink: String
    }
}
