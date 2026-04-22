// swiftlint:disable all

import UIKit

public extension UIFont {
    static let h_xxxl_b = korFont(style: .bold, size: 24)
    static let h_xxxl_sb = korFont(style: .semiBold, size: 24)

    static let h_xxl_b = korFont(style: .bold, size: 22)

    static let h_xl_b = korFont(style: .bold, size: 20)
    static let h_xl_sb = korFont(style: .semiBold, size: 20)
    static let h_xl_r = korFont(style: .regular, size: 20)

    static let b_l_r = korFont(style: .regular, size: 18)
    static let b_m_r = korFont(style: .regular, size: 16)
    static let b_s_sb = korFont(style: .semiBold, size: 14)
    static let b_s_m = korFont(style: .medium, size: 14)
    static let b_s_r = korFont(style: .regular, size: 14)

    static let sub_l_b = korFont(style: .bold, size: 18)
    static let sub_l_m = korFont(style: .medium, size: 18)
    static let sub_m_b = korFont(style: .bold, size: 16)
    static let sub_m_sb = korFont(style: .semiBold, size: 16)
    static let sub_m_m = korFont(style: .medium, size: 16)

    static let cp_s_sb = korFont(style: .semiBold, size: 14)
    static let cp_s_m = korFont(style: .medium, size: 14)
    static let cp_s_r = korFont(style: .regular, size: 14)
    static let cp_xs_sb = korFont(style: .semiBold, size: 12)
    static let cp_xs_r = korFont(style: .regular, size: 12)

    static let btn_m_b = korFont(style: .bold, size: 16)
    static let btn_m_r = korFont(style: .regular, size: 16)
    static let btn_s_r = korFont(style: .regular, size: 14)
    static let btn_xs_r = korFont(style: .regular, size: 12)

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
