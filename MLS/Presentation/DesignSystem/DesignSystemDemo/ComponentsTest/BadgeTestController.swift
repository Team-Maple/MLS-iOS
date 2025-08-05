import UIKit

import DesignSystem

import RxSwift

final class BadgeTestController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let currentBadge = Badge(style: .currentQuest)
    private let preBadge = Badge(style: .preQuest)
    private let nextBadge = Badge(style: .nextQuest)
    private let elementBadge = Badge(style: .element("불 약점"))

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Badge"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension BadgeTestController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension BadgeTestController {
    func addViews() {
        view.addSubview(currentBadge)
        view.addSubview(preBadge)
        view.addSubview(nextBadge)
        view.addSubview(elementBadge)
    }

    func setupConstraints() {
        currentBadge.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        preBadge.snp.makeConstraints { make in
            make.top.equalTo(currentBadge.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        nextBadge.snp.makeConstraints { make in
            make.top.equalTo(preBadge.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        elementBadge.snp.makeConstraints { make in
            make.top.equalTo(nextBadge.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}
