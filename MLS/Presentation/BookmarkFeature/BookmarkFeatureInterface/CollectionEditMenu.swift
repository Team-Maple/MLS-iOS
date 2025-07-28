import UIKit

public enum CollectionSettingMenu: CaseIterable {
    case editBookmark
    case editName
    case delete
    case cancel

    public var title: String {
        switch self {
        case .editBookmark:
            return "컬렉션 북마크 수정"
        case .editName:
            return "컬렉션 이름 수정"
        case .delete:
            return "컬렉션 삭제"
        case .cancel:
            return "취소"
        }
    }

    public var titleColor: UIColor {
        switch self {
        case .delete:
            return .red
        default:
            return .textColor
        }
    }
}
