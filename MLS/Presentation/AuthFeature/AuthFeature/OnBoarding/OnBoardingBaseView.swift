import UIKit

import DesignSystem

/// 온보딩 화면에서 사용하기 위한 헤더(타이틀 버튼 포함)를 가진 뷰
public class OnBoardingBaseView: UIView {
    // MARK: - Components
    public let headerView: NavigationBar = {
        let view = NavigationBar(type: .withUnderLine("다음에 하기"))
        view.rightButton.isHidden = true
        return view
    }()

    // MARK: - init
    init(leftButtonIsHidden: Bool = false) {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
        if leftButtonIsHidden { headerView.leftButton.isHidden = true }
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension OnBoardingBaseView {
    func addViews() {
        addSubview(headerView)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .clearMLS
    }
}
