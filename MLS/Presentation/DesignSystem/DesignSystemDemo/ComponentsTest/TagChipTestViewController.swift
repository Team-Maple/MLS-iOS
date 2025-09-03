import UIKit

import DesignSystem

import RxSwift

final class TagChipTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let normalTagChip = TagChip(style: .normal, text: "text")
    private let searchTagChip = TagChip(style: .search, text: "text")

    private let typeSegmentControl: UISegmentedControl = {
        let items = ["normal", "search"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        return control
    }()

    private let normalTextLabel: UILabel = {
        let label = UILabel()
        label.text = "normal"
        return label
    }()

    private let normalTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "text"
        view.text = "text"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let searchTextLabel: UILabel = {
        let label = UILabel()
        label.text = "search"
        return label
    }()

    private let searchTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "text"
        view.text = "text"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "TagChip"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension TagChipTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
        bind()
    }
}

// MARK: - SetUp
private extension TagChipTestViewController {
    func addViews() {
        view.addSubview(normalTagChip)
        view.addSubview(searchTagChip)
        view.addSubview(typeSegmentControl)
        view.addSubview(normalTextLabel)
        view.addSubview(normalTextField)
        view.addSubview(searchTextLabel)
        view.addSubview(searchTextField)
    }

    func setupConstraints() {
        normalTagChip.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
        }

        searchTagChip.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
        }

        typeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(normalTagChip.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        normalTextLabel.snp.makeConstraints { make in
            make.top.equalTo(typeSegmentControl.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        normalTextField.snp.makeConstraints { make in
            make.top.equalTo(normalTextLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        searchTextLabel.snp.makeConstraints { make in
            make.top.equalTo(normalTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(searchTextLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }

    func bind() {
        typeSegmentControl.rx.selectedSegmentIndex
            .withUnretained(self)
            .subscribe { owner, selectedIndex in
                switch selectedIndex {
                case 0:
                    owner.normalTagChip.isHidden = false
                    owner.searchTagChip.isHidden = true
                default:
                    owner.normalTagChip.isHidden = true
                    owner.searchTagChip.isHidden = false
                }
            }
            .disposed(by: disposeBag)

        normalTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.normalTagChip.text = text
            }
            .disposed(by: disposeBag)

        searchTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.searchTagChip.text = text
            }
            .disposed(by: disposeBag)
    }
}
