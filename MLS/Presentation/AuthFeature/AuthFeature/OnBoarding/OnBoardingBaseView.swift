import UIKit

import DesignSystem

public class OnBoardingBaseView: UIView {
    // MARK: - Components
    public let headerView: NavigationBar = {
        let view = NavigationBar(textButtonTitle: "다음에 하기")
        view.rightButton.isHidden = true
        return view
    }()
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
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
