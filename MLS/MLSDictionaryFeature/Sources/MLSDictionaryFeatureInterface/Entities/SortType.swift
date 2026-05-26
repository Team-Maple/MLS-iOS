public enum SortType: String {
    // 도감 메인 정렬
    case korean = "가나다 순"
    case levelDESC = "레벨 높은 순"
    case levelASC = "레벨 낮은 순"
    case expDESC = "획득 경험치 높은 순"
    case expASC = "획득 경험치 낮은 순"
    case latest = "최신순"

    // 도감 상세 정렬
    case mostAppear = "출현 많은 순"
    case levelLowest = "수락 레벨 낮은 순"
    case levelHighest = "수락 레벨 높은 순"
    case mostDrop = "드롭률 높은 순"

    // 정렬 키 - 이름, 레벨, 경험치
    public var sortKey: String {
        switch self {
        case .latest:
            return "createdAt"
        case .korean:
            return "name"
        case .levelASC, .levelDESC:
            return "level"
        case .expASC, .expDESC:
            return "exp"
        case .mostAppear:
            return "maxSpawnCount"
        case .mostDrop:
            return "dropRate"
        default:
            return ""
        }
    }
    // 정렬 방향 - 오름차순, 내림차순
    public var direction: String {
        switch self {
        case .expASC, .levelASC, .korean:
            return "asc"
        case .expDESC, .levelDESC, .mostDrop, .mostAppear, .latest:
            return "desc"
        default:
            return ""
        }
    }

    // 정렬 파라미터
    public var sortParameter: String {
        return "\(sortKey),\(direction)"
    }
}
