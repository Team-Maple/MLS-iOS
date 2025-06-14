import UIKit

import BaseFeature
import DesignSystem

import RxSwift
import SnapKit

final class GuideAlertTestViewController: UIViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()

    let oneButton = CommonButton(style: .normal, title: "oneButtonModal", disabledTitle: nil)
    let twoButton = CommonButton(style: .normal, title: "twoButtonModal", disabledTitle: nil)

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "GuideAlert"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension GuideAlertTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
        bind()
    }
}

// MARK: - SetUp
private extension GuideAlertTestViewController {
    func addViews() {
        view.addSubview(oneButton)
        view.addSubview(twoButton)
    }

    func setupConstraints() {
        oneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }

        twoButton.snp.makeConstraints { make in
            make.bottom.equalTo(oneButton.snp.top).offset(-16)
            make.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }

    func bind() {
        oneButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                GuideAlertFactory.show(mainText: "버튼 하나", ctaText: "확인", ctaAction: {})
            }
            .disposed(by: disposeBag)

        twoButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                GuideAlertFactory.show(mainText: "버튼 두개", ctaText: "확인", cancelText: "취소", ctaAction: {})
            }
            .disposed(by: disposeBag)
    }
}
