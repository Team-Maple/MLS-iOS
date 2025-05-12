import UIKit

import DesignSystem

internal import SnapKit

public final class TermsAgreementView: UIView {
    // MARK: - Type
    private struct Constant {
        static let imageSize: CGFloat = 45
        static let horizontalInset: CGFloat = 16
        static let dividerSpacing: CGFloat = -16
        static let titleLabelTopSpacing: CGFloat = 24
        static let titleLabelHeight: CGFloat = 30
        static let subTitleLabelTopSpacing: CGFloat = 4
        static let subTitleLabelHeight: CGFloat = 21
        static let stackViewBottomSpacing: CGFloat = -38
        static let bottomButtonBottomSpacing: CGFloat = 30
    }
    
    // MARK: - Properties
    private let headerView: NavigationBarView = {
        let view = NavigationBarView()
        view.rightButton.isHidden = true
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let image = DesignSystemAsset.image(named: "logo")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .h3
        label.textColor = .textColor
        label.text = "필수약관에 동의해주세요"
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .body2
        label.textColor = .neutral500
        label.text = "메랜사를 더 편하게 즐기기 위해 필요한 항목이에요"
        return label
    }()
    
    public let totalAgreeButton: CheckButton = {
        let button = CheckButton(type: .normal, title: "전체동의", subTitle: "(선택 약관 포함)")
        return button
    }()
    
    private let dividerView: DividerView = DividerView()
    
    private let termsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.isUserInteractionEnabled = true
        view.spacing = 4
        return view
    }()
    
    public let oldAgreeButton: CheckButton = {
        let button = CheckButton(type: .list, title: "(필수) 만 14세 이상", subTitle: nil)
        return button
    }()
    
    public let serviceTermsAgreeButton: CheckButton = {
        let button = CheckButton(type: .list, title: "(필수) 메랜사 서비스 이용약관 동의", subTitle: nil)
        return button
    }()
    
    public let personalInformationAgreeButton: CheckButton = {
        let button = CheckButton(type: .list, title: "(필수) 개인정보 수집 및 이용 동의", subTitle: nil)
        return button
    }()
    
    public let marketingAgreeButton: CheckButton = {
        let button = CheckButton(type: .list, title: "(선택) 마케팅 정보 수신 동의", subTitle: nil)
        return button
    }()
    
    private let bottomButton: CommonButton = {
        let button = CommonButton(commonButtonType: .normal, normalTitle: "시작하기", disabledTitle: "시작하기")
        return button
    }()
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        self.addViews()
        self.setupContstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension TermsAgreementView {
    func addViews() {
        self.addSubview(headerView)
        self.addSubview(logoImageView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(totalAgreeButton)
        self.addSubview(bottomButton)
        self.addSubview(termsStackView)
        self.addSubview(dividerView)
        termsStackView.addArrangedSubview(oldAgreeButton)
        termsStackView.addArrangedSubview(serviceTermsAgreeButton)
        termsStackView.addArrangedSubview(personalInformationAgreeButton)
        termsStackView.addArrangedSubview(marketingAgreeButton)
    }

    func setupContstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.size.equalTo(Constant.imageSize)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(Constant.titleLabelTopSpacing)
            make.height.equalTo(Constant.titleLabelHeight)
            make.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.subTitleLabelTopSpacing)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constant.subTitleLabelHeight)
        }
        bottomButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.bottomButtonBottomSpacing)
        }
        termsStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalTo(bottomButton.snp.top).offset(Constant.stackViewBottomSpacing)
        }
        dividerView.snp.makeConstraints { make in
            make.bottom.equalTo(termsStackView.snp.top).offset(Constant.dividerSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        totalAgreeButton.snp.makeConstraints { make in
            make.bottom.equalTo(dividerView.snp.bottom).offset(Constant.dividerSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
    }
}
