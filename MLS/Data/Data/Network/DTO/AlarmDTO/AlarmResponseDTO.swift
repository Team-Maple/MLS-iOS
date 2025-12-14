import DomainInterface

public struct AlarmResponseDTO: Decodable {
    public let contents: [Content]
    public let hasMore: Bool

    public enum Content: Decodable {
        case normal(NormalContent)
        case all(AllContent)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let normal = try? container.decode(NormalContent.self) {
                self = .normal(normal)
                return
            }

            if let all = try? container.decode(AllContent.self) {
                self = .all(all)
                return
            }

            throw DecodingError.typeMismatch(
                Content.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Content type not matched"
                )
            )
        }
    }

    public struct NormalContent: Decodable {
        public let type: String
        public let title: String
        public let link: String
        public let date: String
    }

    public struct AllContent: Decodable {
        public let alrim: NormalContent
        public let alreadyRead: Bool
    }
}

public extension AlarmResponseDTO {
    func toAlarmDomain() -> PagedEntity<AlarmResponse> {
        let alarms = contents.compactMap { content -> AlarmResponse? in
            switch content {
            case .normal(let normal):
                return AlarmResponse(
                    type: normal.type,
                    title: normal.title,
                    link: normal.link,
                    date: normal.date
                )
            case .all(let all):
                return AlarmResponse(
                    type: all.alrim.type,
                    title: all.alrim.title,
                    link: all.alrim.link,
                    date: all.alrim.date
                )
            }
        }
        return PagedEntity(items: alarms, hasMore: hasMore)
    }

    func toAllAlarmDomain() -> PagedEntity<AllAlarmResponse> {
        let allAlarms = contents.compactMap { content -> AllAlarmResponse? in
            switch content {
            case .all(let all):
                return AllAlarmResponse(
                    type: all.alrim.type,
                    title: all.alrim.title,
                    link: all.alrim.link,
                    date: all.alrim.date,
                    alreadyRead: all.alreadyRead
                )
            case .normal:
                return nil
            }
        }
        return PagedEntity(items: allAlarms, hasMore: hasMore)
    }
}
