import UIKit

import DesignSystem

import RxSwift

final class TapButtonTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let tapButton = TapButton(text: "text")

    private let buttonStateToggle = ToggleBox(text: "isSelected")

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "TapButton"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension TapButtonTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
        bind()
    }
}

// MARK: - SetUp
private extension TapButtonTestViewController {
    func addViews() {
        view.addSubview(tapButton)
        view.addSubview(buttonStateToggle)
    }

    func setupConstraints() {
        tapButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
        }

        buttonStateToggle.snp.makeConstraints { make in
            make.top.equalTo(tapButton.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }

    func bind() {
        buttonStateToggle.toggle.rx.isOn
            .withUnretained(self)
            .subscribe { (owner, isOn) in
                owner.tapButton.isSelected = isOn
            }
            .disposed(by: disposeBag)
    }
}
