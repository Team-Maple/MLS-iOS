import UIKit

import BaseFeature
import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

public final class SetCharacterView: CharacterInputView {
    // MARK: - Type

    // MARK: - Properties

    // MARK: - Components
    public let headerView: NavigationBar = {
        let view = NavigationBar(type: .arrowLeft)
        return view
    }()

    // MARK: - init
    override init() {
        super.init()
        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension SetCharacterView {
    func addViews() {
        addSubview(headerView)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constant.verticalInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
    }

    func configureUI() {
        backgroundColor = .clearMLS
        nextButton.updateTitle(title: "완료", disabledTitle: "완료")
    }
}
