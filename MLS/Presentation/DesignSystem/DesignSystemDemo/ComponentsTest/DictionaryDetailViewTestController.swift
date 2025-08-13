import UIKit

import DesignSystem

import RxSwift

final class DictionaryDetailViewTestController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let first = DictionaryDetailListView()
    private let second = DictionaryDetailListView()
    private let third = DictionaryDetailListView()
    private let forth = DictionaryDetailListView()

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "DictionaryDetailView"
        first.update(clickableMainText: "mainText", additionalText: "text", clickableSubText: "text")
        second.update(mainText: "mainText", clickableSubText: "text")
        third.update(mainText: "mainText", subText: "text")
        forth.update(clickableMainText: "mainText", clickableSubText: "text")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension DictionaryDetailViewTestController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension DictionaryDetailViewTestController {
    func addViews() {
        view.addSubview(first)
        view.addSubview(second)
        view.addSubview(third)
        view.addSubview(forth)
    }

    func setupConstraints() {
        first.snp.makeConstraints { make in
            make.horizontalEdges.centerY.equalToSuperview()
        }

        second.snp.makeConstraints { make in
            make.top.equalTo(first.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }

        third.snp.makeConstraints { make in
            make.top.equalTo(second.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }

        forth.snp.makeConstraints { make in
            make.top.equalTo(third.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}
