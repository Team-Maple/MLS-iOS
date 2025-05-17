import UIKit

internal import SnapKit

public final class InputBox: UIStackView {
    // MARK: - Properties
    private var type: InputBoxType = .edit {
        didSet {
            setBorderColor()
        }
    }
    
    private var labelText: String?
    
    private var placeHodler: String?
    
    // MARK: - Components
    public let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public let textField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        return view
    }()
    
    // MARK: - Init
    public init(label: String? = nil, placeHodler: String? = nil) {
        self.labelText = label
        self.placeHodler = placeHodler
        super.init(frame: .zero)
        configureUI(label: label)
    }
    
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
        self.label.attributedText = .makeStyledString(font: .caption, text: label, color: .neutral700, alignment: .left)
    }
    
    func setupTextField(placeHolder: String?) {
        textField.attributedPlaceholder = .makeStyledString(font: .body, text: placeHolder, color: .neutral500, alignment: .left)
    }
    
    func configureUI(label: String?) {
        setupStackView()
        setupLabel(label: label)
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
    
    enum InputBoxType {
        case edit
        case error
        
        var borderColor: UIColor {
            switch self {
            case .edit:
                return .neutral300
            case .error:
                return .error
            }
        }
    }
}
