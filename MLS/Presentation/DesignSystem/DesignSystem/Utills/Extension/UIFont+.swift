import UIKit

public extension UIFont {
    static let h1 = korFont(style: .bold, size: 38)
    static let h2 = korFont(style: .semiBold, size: 26)
    static let h3 = korFont(style: .bold, size: 24)
    static let h4 = korFont(style: .bold, size: 22)
    static let h5 = korFont(style: .bold, size: 20)

    static let subTitle = korFont(style: .medium, size: 16)
    static let subTitleBold = korFont(style: .bold, size: 16)

    static let body = korFont(style: .regular, size: 16)
    static let caption = korFont(style: .regular, size: 14)
    
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
