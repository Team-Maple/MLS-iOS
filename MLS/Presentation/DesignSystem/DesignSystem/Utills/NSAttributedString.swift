import UIKit

extension NSAttributedString {
    static func makeStyledString(
        font: UIFont?,
        text: String?,
        color: UIColor? = .textColor,
        alignment: NSTextAlignment = .center,
        lineHeight: CGFloat = 1.4
    ) -> NSAttributedString? {
        guard let text, let color, let font else { return nil }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = font.lineHeight * lineHeight
        paragraphStyle.maximumLineHeight = font.lineHeight * lineHeight
        paragraphStyle.alignment = alignment
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        return attributedString
    }
}
