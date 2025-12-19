import UIKit

import DesignSystem
import DomainInterface

import SnapKit

final class LoginView: UIView {
    // MARK: - Type
    private enum Constant {
        static let buttonLogoImageSize: CGFloat = 18
        static let buttonLogoImageLeadingInset: CGFloat = 14
        static let buttonHeight: CGFloat = 44
        static let buttonCornerRadius: CGFloat = 8
        static let buttonSpacing: CGFloat = 8
        static let buttonStackViewBottomInset: CGFloat = 16
        static let horizontalInset: CGFloat = 16
        static let buttonCenterXInset: CGFloat = buttonLogoImageLeadingInset + buttonLogoImageSize
        static let labelHeight: CGFloat = 28
        static let subTitleBottomSpacing: CGFloat = -25
        static let recentLogoWidth: CGFloat = 82
        static let recentLogoHeight: CGFloat = 30
        static let recentLogoInset: CGFloat = 8
    }

    // MARK: - Properties
    public let header = NavigationBar(type: .arrowLeft)

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

    private let kakaoLogoImageView: UIImageView = {
        let image = DesignSystemAsset.image(named: "kakaoLogo")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let kakaoLoginLabel: UILabel = {
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

    private let appleLogoImageView: UIImageView = {
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

    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xl_b, text: "모험가님,")
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xl_r, text: "다시 오신 걸 환영해요!")
        return label
    }()

    private let recentLoginImageView: UIImageView = {
        let view = UIImageView(image: DesignSystemAsset.image(named: "recentLoginLogo"))
        view.isHidden = true
        return view
    }()

    // MARK: - init
    init() {
        super.init(frame: .zero)

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
private extension LoginView {
    func addViews() {
        addSubview(loginImageView)
        addSubview(buttonStackView)
        addSubview(recentLoginImageView)

        buttonStackView.addArrangedSubview(kakaoLoginButton)
        buttonStackView.addArrangedSubview(appleLoginButton)

        kakaoLoginButton.addSubview(kakaoLogoImageView)
        kakaoLoginButton.addSubview(kakaoLoginLabel)
        appleLoginButton.addSubview(appleLogoImageView)
        appleLoginButton.addSubview(appleLoginLabel)

        addSubview(header)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }

        loginImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width * 1.49)
            make.top.horizontalEdges.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.buttonStackViewBottomInset)
        }

        kakaoLoginButton.snp.makeConstraints { make in
            make.height.equalTo(Constant.buttonHeight)
        }

        kakaoLogoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constant.buttonLogoImageLeadingInset)
            make.size.equalTo(Constant.buttonLogoImageSize)
        }

        kakaoLoginLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().inset(Constant.buttonCenterXInset)
        }

        appleLoginButton.snp.makeConstraints { make in
            make.height.equalTo(Constant.buttonHeight)
        }

        appleLogoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constant.buttonLogoImageLeadingInset)
            make.size.equalTo(Constant.buttonLogoImageSize)
        }

        appleLoginLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().inset(Constant.buttonCenterXInset)
        }
    }

    func configureUI() {}
}

extension LoginView {
    func update(loginPlatform: LoginPlatform?) {
        mainTitleLabel.removeFromSuperview()
        subTitleLabel.removeFromSuperview()
        guestLoginButton.removeFromSuperview()

        switch loginPlatform {
        case .kakao, .apple:
            // 최근로그인 라벨 추가
            addSubview(mainTitleLabel)
            addSubview(subTitleLabel)

            subTitleLabel.snp.remakeConstraints { make in
                make.bottom.equalTo(buttonStackView.snp.top).offset(Constant.subTitleBottomSpacing)
                make.centerX.equalToSuperview()
                make.height.equalTo(Constant.labelHeight)
            }
            mainTitleLabel.snp.remakeConstraints { make in
                make.bottom.equalTo(subTitleLabel.snp.top)
                make.centerX.equalToSuperview()
                make.height.equalTo(Constant.labelHeight)
            }

            recentLoginImageView.isHidden = false

            recentLoginImageView.snp.remakeConstraints { make in
                switch loginPlatform {
                case .apple:
                    make.leading.equalTo(appleLoginButton).offset(Constant.recentLogoInset)
                    make.bottom.equalTo(appleLoginButton.snp.top).offset(Constant.recentLogoInset)
                case .kakao:
                    make.leading.equalTo(kakaoLoginButton).offset(Constant.recentLogoInset)
                    make.bottom.equalTo(kakaoLoginButton.snp.top).offset(Constant.recentLogoInset)
                default:
                    break
                }
                make.width.equalTo(Constant.recentLogoWidth)
                make.height.equalTo(Constant.recentLogoHeight)
            }
        case nil:
            buttonStackView.addArrangedSubview(guestLoginButton)
            guestLoginButton.snp.remakeConstraints { make in
                make.height.equalTo(Constant.buttonHeight)
            }
            recentLoginImageView.isHidden = true
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}
