import UIKit

import DesignSystem

import RxSwift

final class HeaderTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let mainHeader = Header(style: .main, title: "메인")
    private let filterHeader = Header(style: .filter, title: "필터")

    private let typeSegmentControl: UISegmentedControl = {
        let items = ["main", "filter"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        return control
    }()

    private let mainTextTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "text"
        view.text = "text"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let mainTextTextLabel: UILabel = {
        let label = UILabel()
        label.text = "text"
        return label
    }()

    private let filterTextTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "text"
        view.text = "text"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let filterTextTextLabel: UILabel = {
        let label = UILabel()
        label.text = "text"
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Header"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension HeaderTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
        bind()
    }
}

// MARK: - SetUp
private extension HeaderTestViewController {
    func addViews() {
        view.addSubview(mainHeader)
        view.addSubview(filterHeader)
        view.addSubview(typeSegmentControl)
        view.addSubview(mainTextTextLabel)
        view.addSubview(mainTextTextField)
        view.addSubview(filterTextTextLabel)
        view.addSubview(filterTextTextField)
    }

    func setupConstraints() {
        mainHeader.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        filterHeader.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        typeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(mainHeader.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        mainTextTextLabel.snp.makeConstraints { make in
            make.top.equalTo(typeSegmentControl.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        mainTextTextField.snp.makeConstraints { make in
            make.top.equalTo(mainTextTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        filterTextTextLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTextTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        filterTextTextField.snp.makeConstraints { make in
            make.top.equalTo(filterTextTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        self.view.backgroundColor = .systemBackground
    }

    func bind() {
        typeSegmentControl.rx.selectedSegmentIndex
            .withUnretained(self)
            .subscribe { owner, selectedIndex in
                switch selectedIndex {
                case 0:
                    owner.mainHeader.isHidden = false
                    owner.filterHeader.isHidden = true
                default:
                    owner.mainHeader.isHidden = true
                    owner.filterHeader.isHidden = false
                }
            }
            .disposed(by: disposeBag)

        mainTextTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.mainHeader.titleLabel.attributedText = .makeStyledString(font: owner.mainHeader.style.titleFont, text: text)
            }
            .disposed(by: disposeBag)

        filterTextTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.filterHeader.titleLabel.attributedText = .makeStyledString(font: owner.filterHeader.style.titleFont, text: text)
            }
            .disposed(by: disposeBag)
    }
}
