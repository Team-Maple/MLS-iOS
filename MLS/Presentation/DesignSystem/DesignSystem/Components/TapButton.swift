import UIKit

import SnapKit

public final class TapButton: UIButton {
    // MARK: - Type
    private enum Constant {
        static let height: CGFloat = 34
        static let borderWidth: CGFloat = 1
        static let radius: CGFloat = 17
        static let contentInsets: NSDirectionalEdgeInsets = .init(top: 10, leading: 16, bottom: 10, trailing: 16)
    }

    public let mainTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    // MARK: - Properties
    override public var isSelected: Bool {
        didSet {
            updateUI()
        }
    }

    public var text: String? {
        didSet {
            updateUI()
        }
    }

    // MARK: - init
    public init(text: String? = nil) {
        self.text = text
        super.init(frame: .zero)

        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension TapButton {
    func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }
        addSubview(mainTitleLabel)
        mainTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.contentInsets.leading)
            make.verticalEdges.equalToSuperview().inset(Constant.contentInsets.top)
        }
    }

    func configureUI() {
        backgroundColor = .clear
        layer.borderWidth = Constant.borderWidth
        layer.cornerRadius = Constant.radius
        layer.borderColor = isSelected ? UIColor.primary700.cgColor : UIColor.neutral200.cgColor
    }

    func updateUI() {
        mainTitleLabel.attributedText = .makeStyledString(
            font: isSelected ? .cp_s_sb : .cp_s_r,
            text: text,
            color: isSelected ? .primary700 : .neutral700
        )
        layer.borderColor = isSelected ? UIColor.primary700.cgColor : UIColor.neutral200.cgColor
    }
}
