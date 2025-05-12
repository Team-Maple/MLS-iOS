import UIKit

import DesignSystem

internal import SnapKit

final class TermsAgreementView: UIView {
    // MARK: - Properties
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.rightButton.isHidden = true
        return view
    }()
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        
        self.addViews()
        self.setupContstraints()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension TermsAgreementView {
    func addViews() {
        self.addSubview(headerView)
    }

    func setupContstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }

    func configureUI() { }
}
