import UIKit

internal import SnapKit

public final class GuideAlert: UIView {
    // MARK: - Type
    private enum Constant {
        static let horizontalInset: CGFloat = 20
        static let verticalInset: CGFloat = 20
        static let iconSize: CGFloat = 48
        static let verticalSpacing: CGFloat = 24
        static let stackViewSpacing: CGFloat = 4
        static let stackViewHeight: CGFloat = 48
    }

    // MARK: - Components
    private let warningIconView: UIImageView = {
        let view = UIImageView()
        view.image = .warning
        return view
    }()

    private let textLabel = UILabel()

    public let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constant.stackViewSpacing
        return view
    }()

    public let ctaButton: CommonButton
    public let cancelButton: CommonButton?

    // MARK: - init
    public init(mainText: String, ctaText: String, cancelText: String?, ctaRatio: Double = 0.7) {
        textLabel.attributedText = .makeStyledString(font: .subTitle, text: mainText)
        self.ctaButton = CommonButton(style: .normal, title: ctaText, disabledTitle: nil)
        self.cancelButton = cancelText.map { CommonButton(style: .border, title: $0, disabledTitle: nil) }
        super.init(frame: .zero)

        addViews(cancelText: cancelText)
        setupConstraints(ctaRatio: ctaRatio)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension GuideAlert {
    func addViews(cancelText: String?) {
        addSubview(warningIconView)
        addSubview(textLabel)
        addSubview(buttonStackView)
        if let cancelButton = cancelButton {
            buttonStackView.addArrangedSubview(cancelButton)
        }
        buttonStackView.addArrangedSubview(ctaButton)
    }

    func setupConstraints(ctaRatio: Double) {
        warningIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.verticalInset)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.iconSize)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(warningIconView.snp.bottom).offset(Constant.verticalInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(Constant.verticalSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.verticalInset)
            make.height.equalTo(Constant.stackViewHeight)
        }

        if let cancelButton = cancelButton {
            let cancelRatio = 1 - ctaRatio

            cancelButton.snp.makeConstraints { make in
                make.width.equalTo(buttonStackView.snp.width).multipliedBy(cancelRatio).offset(-Constant.stackViewSpacing)
            }
            ctaButton.snp.makeConstraints { make in
                make.width.equalTo(buttonStackView.snp.width).multipliedBy(ctaRatio).offset(-Constant.stackViewSpacing)
            }
        } else {
            ctaButton.snp.makeConstraints { make in
                make.width.equalTo(buttonStackView.snp.width)
            }
        }
    }
}
