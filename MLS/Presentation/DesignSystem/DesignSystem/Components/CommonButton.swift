import UIKit

internal import SnapKit

public final class CommonButton: UIButton {
    // MARK: - Type
    public enum CommonButtonType {
        case normal
        case text
    }
    private struct Constant {
        static let height: CGFloat = 48
    }
    // MARK: - Properties
    private let commonButtonType: CommonButtonType
    
    // MARK: - init
    public init(commonButtonType: CommonButtonType, normalTitle: String?, disabledTitle: String?) {
        self.commonButtonType = commonButtonType
        super.init(frame: .zero)
        self.configureUI(normalTitle: normalTitle, disabledTitle: disabledTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension CommonButton {
    func configureUI(normalTitle: String?, disabledTitle: String?) {
        
        switch commonButtonType {
        case .normal:
            self.setTitle(normalTitle, for: .normal)
            self.setTitle(disabledTitle, for: .disabled)
            self.titleLabel?.font = .subTitleBold
            self.setBackgroundImage(UIImage.fromColor(.primary700), for: .normal)
            self.setBackgroundImage(UIImage.fromColor(.neutral300), for: .disabled)
            self.layer.cornerRadius = 8
            self.clipsToBounds = true
            self.snp.makeConstraints { make in make.height.equalTo(Constant.height) }
        case .text:
            self.titleLabel?.font = .body2
            if let textButtonTitle = normalTitle,
               let disabledTitle = disabledTitle,
               let lineHeight = UIFont.body2?.lineHeight {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = lineHeight * 1.2
                paragraphStyle.maximumLineHeight = lineHeight * 1.2
                paragraphStyle.alignment = .center
                
                let enabledAttributedString = NSAttributedString(
                    string: textButtonTitle,
                    attributes: [
                        .underlineStyle: NSUnderlineStyle.single.rawValue,
                        .underlineColor: UIColor.neutral700,
                        .paragraphStyle: paragraphStyle
                    ]
                )
                let disabledAttributedString = NSAttributedString(
                    string: disabledTitle,
                    attributes: [
                        .underlineStyle: NSUnderlineStyle.single.rawValue,
                        .underlineColor: UIColor.neutral700,
                        .paragraphStyle: paragraphStyle
                    ]
                )
                self.setTitleColor(.neutral700, for: .normal)
                self.setTitleColor(.neutral700, for: .disabled)
                self.setAttributedTitle(enabledAttributedString, for: .normal)
                self.setAttributedTitle(disabledAttributedString, for: .disabled)
            }
        }
    }
}
