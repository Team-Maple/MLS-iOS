import UIKit

extension NSAttributedString {
    static func makeCustomFontString(font: UIFont?, text: String?, color: UIColor? = .textColor) -> NSAttributedString? {
        guard let text, let color else { return nil }
        let paragraphStyle = NSMutableParagraphStyle()
        if let lineHeight = font?.lineHeight {
            paragraphStyle.minimumLineHeight = lineHeight * 1.4
            paragraphStyle.maximumLineHeight = lineHeight * 1.4
        }
        paragraphStyle.alignment = .center
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: color,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        return attributedString
    }
}
