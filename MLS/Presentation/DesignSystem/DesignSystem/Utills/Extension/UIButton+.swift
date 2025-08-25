import UIKit

extension UIButton {
    func setUnderlinedTitle(title: String, font: UIFont?, state: UIControl.State = .normal, textInsets: UIEdgeInsets = .zero) {
        guard let font = font else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 0
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.maximumLineHeight = font.lineHeight * 1.17

        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: font,
            .paragraphStyle: paragraphStyle
        ]

        let attributedString = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(attributedString, for: state)
        titleEdgeInsets = textInsets
    }
}
