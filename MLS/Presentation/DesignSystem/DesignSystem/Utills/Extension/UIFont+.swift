import UIKit

public extension UIFont {
    static let h1 = korFont(style: .bold, size: 32)
    static let h2 = korFont(style: .semiBold, size: 28)
    static let h3 = korFont(style: .bold, size: 20)
    static let subTitle = korFont(style: .regular, size: 16)
    static let subTitleBold = korFont(style: .bold, size: 16)
    static let body = korFont(style: .regular, size: 16)
    static let body2 = korFont(style: .medium, size: 14)
    static let caption = korFont(style: .regular, size: 12)
    
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
