enum MyPageViewType: CaseIterable {
    case settings //설정Section
    case customerSupport // 고객지원 Section
    
    var title: String {
        switch self {
        case .settings: return "설정"
        case .customerSupport: return "고객지원"
        }
    }
    // 섹셜변 버튼 제목
    var buttonTitle: [ButtonType] {
        switch self {
        case .settings:
            return [.notificationSetting, .characterSetting]
        case .customerSupport:
            return [.event, .notification, .patchNote, .policy]
        }
    }
}

enum ButtonType: String {
    // MARK: - 설정 Section 버튼
    case notificationSetting = "알림 설정"
    case characterSetting = "캐릭터 정보 설정"
    // MARK: - 고객지원 Section 버튼
    case event = "메이플랜드 이벤트"
    case notification = "메이플랜드 공지사항"
    case patchNote = "메이플랜드 패치노트"
    case policy = "약관 및 정책"
}
