import UIKit

public extension UIColor {
    static let primary900 = UIColor(hexCode: "EE500C")
    static let primary700 = UIColor(hexCode: "FF5C00")
    static let primary500 = UIColor(hexCode: "FF7D33")
    static let primary300 = UIColor(hexCode: "FF9D66")
    static let primary100 = UIColor(hexCode: "FFBE9A")
    static let primary50 = UIColor(hexCode: "FFE6D8")
    static let primary25 = UIColor(hexCode: "FFF1E9")

    static let secondary = UIColor(hexCode: "FFAA00")
    static let textColor = UIColor(hexCode: "1D1D1F")

    static let neutral900 = UIColor(hexCode: "313131")
    static let neutral700 = UIColor(hexCode: "575757")
    static let neutral600 = UIColor(hexCode: "848484")
    static let neutral500 = UIColor(hexCode: "AFAFAF")
    static let neutral300 = UIColor(hexCode: "CFCFCF")
    static let neutral200 = UIColor(hexCode: "E9E9E9")
    static let neutral100 = UIColor(hexCode: "F5F5F5")

    static let whiteMLS = UIColor(hexCode: "FFFFFF")
    static let clearMLS = UIColor(hexCode: "FFFFFF", alpha: 0)

    static let error900 = UIColor(hexCode: "FF4B4B")
    static let error100 = UIColor(hexCode: "FFEFEF")

    static let success = UIColor(hexCode: "15CC00")
    static let redMLS = UIColor(hexCode: "FF0000")
    static let overlays = UIColor(hexCode: "000000", alpha: 0.2)

    static let listMonster = UIColor(hexCode: "FFEFCE")
    static let listItem = UIColor(hexCode: "F1EEFC")
    static let listMap = UIColor(hexCode: "EEF9E0")
    static let listNPC = UIColor(hexCode: "E0EFF9")
    static let listQuest = UIColor(hexCode: "FFECEF")

    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
