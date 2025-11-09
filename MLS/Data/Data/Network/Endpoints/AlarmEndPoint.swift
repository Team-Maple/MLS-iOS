import DomainInterface

public enum AlarmEndPoint {
    static let base = "https://api.mapleland.kro.kr"

    public static func fetchPatchNotes(query: Encodable) -> ResponsableEndPoint<AlarmResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/alrim/list/patch-notes",
            method: .GET,
            query: query
        )
    }

    public static func fetchNotices(query: Encodable) -> ResponsableEndPoint<AlarmResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/alrim/list/notices",
            method: .GET,
            query: query
        )
    }

    public static func fetchOutdatedEvents(query: Encodable) -> ResponsableEndPoint<AlarmResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/alrim/list/events/outdated",
            method: .GET,
            query: query
        )
    }

    public static func fetchOngoingEvents(query: Encodable) -> ResponsableEndPoint<AlarmResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/alrim/list/events/ongoing",
            method: .GET,
            query: query
        )
    }

    public static func fetchAll(query: Encodable) -> ResponsableEndPoint<AlarmResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/alrim/all",
            method: .GET,
            query: query
        )
    }

    public static func setRead(query: Encodable) -> EndPoint {
        .init(
            baseURL: base,
            path: "/api/v1/alrim/set-read",
            method: .POST,
            query: query
        )
    }
}
