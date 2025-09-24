import UIKit

public extension NSAttributedString {
    static func makeStyledString(
        font: UIFont?,
        text: String?,
        color: UIColor? = .textColor,
        alignment: NSTextAlignment = .center,
        lineHeight: CGFloat = 1.17
    ) -> NSAttributedString? {
        guard let text, let color, let font else { return nil }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 0
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = alignment

        let actualLineHeight = font.lineHeight * lineHeight
        let baselineOffset = (actualLineHeight - font.lineHeight) / 2

        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle,
                .baselineOffset: baselineOffset
            ]
        )
        return attributedString
    }

    static func makeStyledUnderlinedString(
            font: UIFont?,
            text: String?,
            color: UIColor? = .textColor,
            alignment: NSTextAlignment = .center,
            lineHeight: CGFloat = 1.17,
            underlineStyle: NSUnderlineStyle = .single
        ) -> NSAttributedString? {
            guard let text, let color, let font else { return nil }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = 0
            paragraphStyle.lineBreakMode = .byTruncatingTail
            paragraphStyle.maximumLineHeight = font.lineHeight * lineHeight
            paragraphStyle.alignment = alignment

            let attributedString = NSAttributedString(
                string: text,
                attributes: [
                    .font: font,
                    .foregroundColor: color,
                    .paragraphStyle: paragraphStyle,
                    .underlineStyle: underlineStyle.rawValue
                ]
            )

            return attributedString
        }
}
