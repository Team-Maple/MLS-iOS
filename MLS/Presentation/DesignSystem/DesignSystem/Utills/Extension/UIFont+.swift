import UIKit

public extension UIFont {
    static let heading1 = korFont(style: .bold, size: 38)
    static let heading2 = korFont(style: .semiBold, size: 26)
    static let heading3 = korFont(style: .bold, size: 24)
    static let heading3SemiBold = korFont(style: .semiBold, size: 24)
    static let heading4 = korFont(style: .bold, size: 22)
    static let heading5 = korFont(style: .bold, size: 20)
    static let heading5SemiBold = korFont(style: .semiBold, size: 20)
    static let heading5Regular = korFont(style: .regular, size: 20)

    static let subTitle = korFont(style: .medium, size: 16)
    static let subTitleBold = korFont(style: .bold, size: 16)

    static let body = korFont(style: .regular, size: 16)
    static let body2 = korFont(style: .regular, size: 18)
    static let caption = korFont(style: .regular, size: 14)
    static let captionBold = korFont(style: .regular, size: 14)

    static func korFont(style: FontStyle, size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard\(style.rawValue)", size: size)
    }

    enum FontStyle: String {
        case bold = "-Bold"
        case semiBold = "-SemiBold"
        case medium = "-Medium"
        case regular = "-Regular"
    }
}
