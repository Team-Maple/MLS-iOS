import UIKit

import SnapKit

public final class InputBox: UIStackView {
    // MARK: - Properties
    private var type: InputBoxType = .edit {
        didSet {
            setBorderColor()
        }
    }

    // MARK: - Components
    public let label = UILabel()
    public let textField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    public lazy var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.neutral300.cgColor

        view.addSubview(textField)

        textField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        return view
    }()

    // MARK: - Init
    public init(label: String? = nil, placeHodler: String? = nil) {
        super.init(frame: .zero)
        configureUI(label: label, placeHodler: placeHodler)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension InputBox {
    func setupStackView() {
        addArrangedSubview(label)
        addArrangedSubview(borderView)

        spacing = 4
        axis = .vertical
        alignment = .leading
    }

    func setupLabel(label: String?) {
        self.label.attributedText = .makeStyledString(font: .b_s_r, text: label, color: .neutral700, alignment: .left)
    }

    func setupTextField(placeHolder: String?) {
        textField.attributedPlaceholder = .makeStyledString(font: .b_m_r, text: placeHolder, color: .neutral500, alignment: .left)
    }

    func setupConstaraints() {
        borderView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
    }

    func configureUI(label: String?, placeHodler: String?) {
        setupStackView()
        setupLabel(label: label)
        setupTextField(placeHolder: placeHodler)
        setupConstaraints()
    }

    func setBorderColor() {
        borderView.layer.borderColor = type.borderColor.cgColor
    }
}

// MARK: - Mothods
public extension InputBox {
    func setType(type: InputBoxType) {
        self.type = type
    }
}

public enum InputBoxType {
    case edit
    case error

    var borderColor: UIColor {
        switch self {
        case .edit:
            return .neutral300
        case .error:
            return .error900
        }
    }
}
