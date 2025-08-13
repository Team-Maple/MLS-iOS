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
}
