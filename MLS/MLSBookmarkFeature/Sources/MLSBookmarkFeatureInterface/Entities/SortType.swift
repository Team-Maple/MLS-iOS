public enum SortType: String {
    case korean = "가나다 순"
    case levelDESC = "레벨 높은 순"
    case levelASC = "레벨 낮은 순"
    case expDESC = "획득 경험치 높은 순"
    case expASC = "획득 경험치 낮은 순"
    case latest = "최신순"
    case mostAppear = "출현 많은 순"
    case levelLowest = "수락 레벨 낮은 순"
    case levelHighest = "수락 레벨 높은 순"
    case mostDrop = "드롭률 높은 순"

    public var sortKey: String {
        switch self {
        case .korean: return "name"
        case .levelDESC, .levelASC: return "level"
        case .expDESC, .expASC: return "exp"
        case .latest: return "createdAt"
        case .mostAppear: return "count"
        case .levelLowest, .levelHighest: return "minLevel"
        case .mostDrop: return "dropRate"
        }
    }

    public var direction: String {
        switch self {
        case .korean, .levelASC, .expASC, .latest, .mostAppear, .levelLowest, .mostDrop:
            return "asc"
        case .levelDESC, .expDESC, .levelHighest:
            return "desc"
        }
    }

    public var sortParameter: String {
        return "\(sortKey),\(direction)"
    }
}
