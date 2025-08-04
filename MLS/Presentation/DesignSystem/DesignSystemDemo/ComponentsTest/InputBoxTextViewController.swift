import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

final class InputBoxTextViewController: UIViewController {
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var inputBox = InputBox(label: "label", placeHodler: "placeHolder")

    private let typeSegmentControl: UISegmentedControl = {
        let items = ["edit", "error"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        return control
    }()

    private let labelTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "label"
        view.text = "label"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let placeHolderTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "placeHolder"
        view.text = "placeHolder"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let textTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "text"
        view.text = "text"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let labelTextLabel: UILabel = {
        let label = UILabel()
        label.text = "label"
        return label
    }()

    private let placeHolderTextLabel: UILabel = {
        let label = UILabel()
        label.text = "placeHolder"
        return label
    }()

    private let textTextLabel: UILabel = {
        let label = UILabel()
        label.text = "text"
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "InputBox"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Life Cycle
extension InputBoxTextViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
        self.setupConstraints()
        self.configureUI()
        self.bind()
    }
}

// MARK: - SetUp
private extension InputBoxTextViewController {
    func addViews() {
        view.addSubview(inputBox)
        view.addSubview(typeSegmentControl)
        view.addSubview(labelTextLabel)
        view.addSubview(labelTextField)
        view.addSubview(placeHolderTextLabel)
        view.addSubview(placeHolderTextField)
        view.addSubview(textTextLabel)
        view.addSubview(textTextField)
    }

    func setupConstraints() {
        inputBox.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        typeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(inputBox.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        labelTextLabel.snp.makeConstraints { make in
            make.top.equalTo(typeSegmentControl.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        labelTextField.snp.makeConstraints { make in
            make.top.equalTo(labelTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        placeHolderTextLabel.snp.makeConstraints { make in
            make.top.equalTo(labelTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        placeHolderTextField.snp.makeConstraints { make in
            make.top.equalTo(placeHolderTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        textTextLabel.snp.makeConstraints { make in
            make.top.equalTo(placeHolderTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        textTextField.snp.makeConstraints { make in
            make.top.equalTo(textTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }

    func bind() {
        typeSegmentControl.rx.selectedSegmentIndex
            .withUnretained(self)
            .subscribe { (owner, index) in
                if index == 0 {
                    owner.inputBox.setType(type: .edit)
                } else {
                    owner.inputBox.setType(type: .error)
                }
            }
            .disposed(by: disposeBag)

        labelTextField.rx.text
            .withUnretained(self)
            .subscribe { owner, text in
                owner.inputBox.label.attributedText = .makeStyledString(font: .b_s_r, text: text, color: .neutral700, alignment: .left)
            }
            .disposed(by: disposeBag)

        placeHolderTextField.rx.text
            .withUnretained(self)
            .subscribe { owner, text in
                owner.inputBox.textField.attributedPlaceholder = .makeStyledString(font: .b_m_r, text: text, color: .neutral500, alignment: .left)
            }
            .disposed(by: disposeBag)

        textTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.inputBox.textField.attributedText = .makeStyledString(font: .b_m_r, text: text, alignment: .left)
            }
            .disposed(by: disposeBag)
    }
}
