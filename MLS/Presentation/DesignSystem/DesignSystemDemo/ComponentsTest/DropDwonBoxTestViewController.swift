import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

final class DropDownBoxTextViewController: UIViewController {
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var dropDownBox = DropDownBox(menus: ["1", "2"])
    private lazy var inputBox = dropDownBox.inputBox

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

    private let countTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "count"
        view.text = "4"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.keyboardType = .numberPad
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

    private let countTextLabel: UILabel = {
        let label = UILabel()
        label.text = "메뉴개수"
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "DropDownBox"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Life Cycle
extension DropDownBoxTextViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
        self.setupConstraints()
        self.configureUI()
        self.bind()
    }
}

// MARK: - SetUp
private extension DropDownBoxTextViewController {
    func addViews() {
        view.addSubview(labelTextLabel)
        view.addSubview(labelTextField)
        view.addSubview(placeHolderTextLabel)
        view.addSubview(placeHolderTextField)
        view.addSubview(countTextLabel)
        view.addSubview(countTextField)
        view.addSubview(dropDownBox)
    }

    func setupConstraints() {
        dropDownBox.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        labelTextLabel.snp.makeConstraints { make in
            make.top.equalTo(dropDownBox.snp.bottom).offset(10)
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

        countTextLabel.snp.makeConstraints { make in
            make.top.equalTo(placeHolderTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        countTextField.snp.makeConstraints { make in
            make.top.equalTo(countTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }

    func bind() {
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

        countTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, count) in
                guard let count = Int(count ?? "") else { return }
                owner.dropDownBox.menus = []
                for index in 1...count {
                    owner.dropDownBox.menus.append("메뉴\(index)")
                }
            }
            .disposed(by: disposeBag)
    }
}
