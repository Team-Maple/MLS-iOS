import UIKit

import BaseFeature
import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

public final class OnBoardingInputView: CharacterInputView {
    // MARK: - Type

    // MARK: - Properties

    // MARK: - Components
    public let headerView: NavigationBar = {
        let view = NavigationBar(type: .withUnderLine("다음에 하기"))
        return view
    }()

    // MARK: - init
    init(leftButtonIsHidden: Bool = false, underlineTextButtonIsHidden: Bool = false) {
        super.init()
        addViews()
        setupConstraints()
        configureUI()
        if leftButtonIsHidden { headerView.leftButton.isHidden = true }
        if underlineTextButtonIsHidden { headerView.underlineTextButton.isHidden = true }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension OnBoardingInputView {
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
    }
}
