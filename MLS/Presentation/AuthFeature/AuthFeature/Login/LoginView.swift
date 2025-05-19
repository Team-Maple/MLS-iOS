import UIKit

import DesignSystem

internal import SnapKit

final class LoginView: UIView {
    // MARK: - Type
    private struct Constant {
        static let buttonLogoImageSize: CGFloat = 18
        static let buttonLogoImageLeadingInset: CGFloat = 14
        static let buttonHeight: CGFloat = 44
        static let buttonCornerRadius: CGFloat = 8
        static let buttonSpacing: CGFloat = 8
        static let buttonStackViewBottomInset: CGFloat = 16
        static let horizontalInset: CGFloat = 16
        static let buttonCenterXInset: CGFloat = buttonLogoImageLeadingInset + buttonLogoImageSize
    }
    
    // MARK: - Properties
    private let loginImageView: UIImageView = {
        let image = DesignSystemAsset.image(named: "Login_KV_img")
        let view = UIImageView(image: image)
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Constant.buttonSpacing
        return view
    }()
    
    let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(hexCode: "#FEE500", alpha: 1)
        button.layer.cornerRadius = Constant.buttonCornerRadius
        return button
    }()
    
    let kakaoLogoImageView: UIImageView = {
        let image = DesignSystemAsset.image(named: "kakaoLogo")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let kakaoLoginLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .korFont(style: .semiBold, size: 15), text: "카카오로 계속하기", color: .init(hexCode: "#000000", alpha: 0.85))
        return label
    }()
    
    let appleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(hexCode: "#000000", alpha: 1)
        button.layer.cornerRadius = Constant.buttonCornerRadius
        return button
    }()
    
    let appleLogoImageView: UIImageView = {
        let image = DesignSystemAsset.image(named: "AppleLogo")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let appleLoginLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .korFont(style: .semiBold, size: 15), text: "Apple로 계속하기", color: .init(hexCode: "#FFFFFF"))
        return label
    }()
    
    let guestLoginButton: CommonButton = {
        let button = CommonButton(style: .text, title: "가입 없이 둘러보기", disabledTitle: "가입 없이 둘러보기")
        return button
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
private extension LoginView {
    func addViews() {
        self.addSubview(loginImageView)
        self.addSubview(buttonStackView)
        self.buttonStackView.addArrangedSubview(kakaoLoginButton)
        self.buttonStackView.addArrangedSubview(appleLoginButton)
        self.buttonStackView.addArrangedSubview(guestLoginButton)
        
        self.kakaoLoginButton.addSubview(kakaoLogoImageView)
        self.kakaoLoginButton.addSubview(kakaoLoginLabel)
        
        self.appleLoginButton.addSubview(appleLogoImageView)
        self.appleLoginButton.addSubview(appleLoginLabel)
    }

    func setupContstraints() {
        self.loginImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width * 1.49)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.buttonStackViewBottomInset)
        }
        
        self.kakaoLoginButton.snp.makeConstraints { make in
            make.height.equalTo(Constant.buttonHeight)
        }
        
        self.kakaoLogoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constant.buttonLogoImageLeadingInset)
            make.size.equalTo(Constant.buttonLogoImageSize)
        }
        
        self.kakaoLoginLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().inset(Constant.buttonCenterXInset)
        }
        
        self.appleLoginButton.snp.makeConstraints { make in
            make.height.equalTo(Constant.buttonHeight)
        }
        
        self.appleLogoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constant.buttonLogoImageLeadingInset)
            make.size.equalTo(Constant.buttonLogoImageSize)
        }
        
        self.appleLoginLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().inset(Constant.buttonCenterXInset)
        }
        
        self.guestLoginButton.snp.makeConstraints { make in
            make.height.equalTo(Constant.buttonHeight)
        }
    }

    func configureUI() { }
}
