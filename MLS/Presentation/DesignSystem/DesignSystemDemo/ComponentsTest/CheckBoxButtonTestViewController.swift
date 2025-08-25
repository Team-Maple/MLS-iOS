import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

final class CheckBoxButtonTestViewController: UIViewController {
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private var normalButton = CheckBoxButton(style: .normal, mainTitle: nil, subTitle: nil)
    private var smallButton = CheckBoxButton(style: .listSmall, mainTitle: nil, subTitle: nil)
    private var mediumButton = CheckBoxButton(style: .listMedium, mainTitle: nil, subTitle: nil)
    private var largeButton = CheckBoxButton(style: .listLarge, mainTitle: nil, subTitle: nil)

    private let typeSegmentControl: UISegmentedControl = {
        let items = ["normal", "listSmall", "listMedium", "listLarge"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        return control
    }()

    private let mainTitleTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "MainTitle"
        view.text = "MainTitle"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let subTitleTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "SubTitle"
        view.text = "SubTitle"
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let mainTitleTextLabel: UILabel = {
        let label = UILabel()
        label.text = "MainTitle"
        return label
    }()

    private let subTitleTextLabel: UILabel = {
        let label = UILabel()
        label.text = "SubTitle"
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "CheckBoxButton"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Life Cycle
extension CheckBoxButtonTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
        self.setupConstraints()
        self.configureUI()
        self.bind()
    }
}

// MARK: - SetUp
private extension CheckBoxButtonTestViewController {
    func addViews() {
        view.addSubview(normalButton)
        view.addSubview(smallButton)
        view.addSubview(mediumButton)
        view.addSubview(largeButton)
        view.addSubview(typeSegmentControl)
        view.addSubview(mainTitleTextLabel)
        view.addSubview(mainTitleTextField)
        view.addSubview(subTitleTextLabel)
        view.addSubview(subTitleTextField)
    }

    func setupConstraints() {
        normalButton.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        smallButton.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        mediumButton.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        largeButton.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        typeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(normalButton.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        mainTitleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(typeSegmentControl.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        mainTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(mainTitleTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        subTitleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitleTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        subTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }

    func bind() {
        normalButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.normalButton.isSelected.toggle()
            }
            .disposed(by: disposeBag)

        smallButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.smallButton.isSelected.toggle()
            }
            .disposed(by: disposeBag)

        mediumButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.mediumButton.isSelected.toggle()
            }
            .disposed(by: disposeBag)

        largeButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.largeButton.isSelected.toggle()
            }
            .disposed(by: disposeBag)

        typeSegmentControl.rx.selectedSegmentIndex
            .withUnretained(self)
            .subscribe { (owner, index) in
                switch index {
                case 0:
                    owner.normalButton.isHidden = false
                    owner.smallButton.isHidden = true
                    owner.mediumButton.isHidden = true
                    owner.largeButton.isHidden = true
                case 1:
                    owner.normalButton.isHidden = true
                    owner.smallButton.isHidden = false
                    owner.mediumButton.isHidden = true
                    owner.largeButton.isHidden = true
                case 2:
                    owner.normalButton.isHidden = true
                    owner.smallButton.isHidden = true
                    owner.mediumButton.isHidden = false
                    owner.largeButton.isHidden = true
                default:
                    owner.normalButton.isHidden = true
                    owner.smallButton.isHidden = true
                    owner.mediumButton.isHidden = true
                    owner.largeButton.isHidden = false
                }
            }
            .disposed(by: disposeBag)

        mainTitleTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.normalButton.mainTitle = text
                owner.smallButton.mainTitle = text
                owner.mediumButton.mainTitle = text
                owner.largeButton.mainTitle = text
            }
            .disposed(by: disposeBag)

        subTitleTextField.rx.text
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.normalButton.subTitle = text
            }
            .disposed(by: disposeBag)
    }
}
