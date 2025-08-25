import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

final class ErrorMessageTextViewController: UIViewController {
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var errorMessage = ErrorMessage(message: nil)

    private let messageTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "message"
        view.text = "error"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let messageTextLabel: UILabel = {
        let label = UILabel()
        label.text = "message"
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "ErrorMessage"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Life Cycle
extension ErrorMessageTextViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
        self.setupConstraints()
        self.configureUI()
        self.bind()
    }
}

// MARK: - SetUp
private extension ErrorMessageTextViewController {
    func addViews() {
        view.addSubview(errorMessage)
        view.addSubview(messageTextLabel)
        view.addSubview(messageTextField)
    }

    func setupConstraints() {
        errorMessage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
        }

        messageTextLabel.snp.makeConstraints { make in
            make.top.equalTo(errorMessage.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        messageTextField.snp.makeConstraints { make in
            make.top.equalTo(messageTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }

    func bind() {
        messageTextField.rx.text
            .withUnretained(self)
            .subscribe { owner, message in
                owner.errorMessage.label.attributedText = .makeStyledString(font: .b_s_r, text: message, color: .error900)
            }
            .disposed(by: disposeBag)
    }
}
