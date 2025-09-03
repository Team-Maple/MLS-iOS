import UIKit

import DesignSystem

import RxSwift

final class CommonButtonTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let commonButton = CommonButton(style: .normal, title: "NormalTitle", disabledTitle: "DisabledTitle")
    private let textButton = CommonButton(style: .text, title: "NormalTitle", disabledTitle: "DisabledTitle")
    private let borderButton = CommonButton(style: .border, title: "NormalTitle", disabledTitle: "DisabledTitle")

    private let typeSegmentControl: UISegmentedControl = {
        let items = ["normal", "text", "border"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        return control
    }()

    private let buttonStateToggle = ToggleBox(text: "isEnabled")
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "CommonButton"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension CommonButtonTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
        bind()
    }
}

// MARK: - SetUp
private extension CommonButtonTestViewController {
    func addViews() {
        view.addSubview(commonButton)
        view.addSubview(textButton)
        view.addSubview(borderButton)
        view.addSubview(typeSegmentControl)
        view.addSubview(buttonStateToggle)
    }

    func setupConstraints() {
        commonButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        textButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
        }

        borderButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        typeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(textButton.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        buttonStateToggle.snp.makeConstraints { make in
            make.top.equalTo(typeSegmentControl.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.title = "CommonButton"
    }

    func bind() {
        self.typeSegmentControl.rx.selectedSegmentIndex
            .withUnretained(self)
            .subscribe { owner, selectedIndex in
                switch selectedIndex {
                case 0:
                    owner.commonButton.isHidden = false
                    owner.textButton.isHidden = true
                    owner.borderButton.isHidden = true
                case 1:
                    owner.commonButton.isHidden = true
                    owner.textButton.isHidden = false
                    owner.borderButton.isHidden = true
                default:
                    owner.commonButton.isHidden = true
                    owner.textButton.isHidden = true
                    owner.borderButton.isHidden = false
                }
            }
            .disposed(by: disposeBag)

        self.buttonStateToggle.toggle.rx.isOn
            .withUnretained(self)
            .subscribe { (owner, isOn) in
                owner.commonButton.isEnabled = isOn
                owner.textButton.isEnabled = isOn
                owner.borderButton.isEnabled = isOn
            }
            .disposed(by: disposeBag)
    }
}
