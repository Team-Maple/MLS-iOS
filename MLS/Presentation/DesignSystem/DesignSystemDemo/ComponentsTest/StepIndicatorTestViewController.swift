import UIKit

import DesignSystem

import RxSwift
import SnapKit

final class StepIndicatorTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()

    let firstIndicator = StepIndicator(circleCount: 3)
    let secondIndicator = StepIndicator(circleCount: 3)
    let thirdIndicator = StepIndicator(circleCount: 3)

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "StepIndicator"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension StepIndicatorTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension StepIndicatorTestViewController {
    func addViews() {
        view.addSubview(firstIndicator)
        view.addSubview(secondIndicator)
        view.addSubview(thirdIndicator)
    }

    func setupConstraints() {
        firstIndicator.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
        }

        secondIndicator.snp.makeConstraints { make in
            make.top.equalTo(firstIndicator.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        thirdIndicator.snp.makeConstraints { make in
            make.top.equalTo(secondIndicator.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground

        firstIndicator.selectIndicator(index: 0)
        secondIndicator.selectIndicator(index: 1)
        thirdIndicator.selectIndicator(index: 2)
    }
}
