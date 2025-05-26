import UIKit

import DesignSystem

internal import SnapKit

public final class ModalView: UIView {
    // MARK: - Type
    private enum Constant {
        static let horizontalInset = 20
        static let verticalInset = 16
        static let verticalSpacing = 8
    }
    
    // MARK: - Components
    private let boldTextLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h5, text: "메이플랜드 이벤트 알림을 위해\n알림 허용이 필요해요", alignment: .left)
        label.numberOfLines = 2
        return label
    }()
    
    private let regularTeextLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .body, text: "놓치지 않도록 푸시 알림으로\n가장 먼저 알려들리게요.", color: .neutral700, alignment: .left)
        label.numberOfLines = 2
        return label
    }()
    
    private let agreeButton = CommonButton(style: .normal, title: "동의하고 알림 받기", disabledTitle: nil)
    
    private let disagreeButton = CommonButton(style: .text, title: "다음에 하기", disabledTitle: nil)
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension ModalView {
    func addViews() {
        addSubview(boldTextLabel)
        addSubview(regularTeextLabel)
        addSubview(agreeButton)
        addSubview(disagreeButton)
    }

    func setupConstraints() {
        boldTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        
        regularTeextLabel.snp.makeConstraints { make in
            make.top.equalTo(boldTextLabel.snp.bottom).offset(Constant.verticalSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        
        agreeButton.snp.makeConstraints { make in
            make.top.equalTo(regularTeextLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        
        disagreeButton.snp.makeConstraints { make in
            make.top.equalTo(agreeButton.snp.bottom).offset(Constant.verticalSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.verticalInset)
        }
    }
}
