public enum CustomerSupportType {
    case event
    case announcement
    case patchNote
    case terms

    public var detailTitle: String {
        switch self {
        case .event:
            "이벤트"
        case .announcement:
            "공지사항"
        case .patchNote:
            "패치노트"
        case .terms:
            "약관 및 정책"
        }
    }
}
