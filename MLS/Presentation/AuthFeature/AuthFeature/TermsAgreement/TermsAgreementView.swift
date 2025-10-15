import UIKit

import DesignSystem

import SnapKit

public final class TermsAgreementView: UIView {
    // MARK: - Type
    private enum Constant {
        static let imageTopSpacing: CGFloat = 20
        static let imageSize: CGFloat = 60
        static let horizontalInset: CGFloat = 16
        static let totalButtonBottomSpacing: CGFloat = -14
        static let titleLabelTopSpacing: CGFloat = 16
        static let titleLabelHeight: CGFloat = 30
        static let subTitleLabelTopSpacing: CGFloat = 4
        static let subTitleLabelHeight: CGFloat = 21
        static let stackViewBottomSpacing: CGFloat = -26
        static let bottomButtonBottomSpacing: CGFloat = 16
        static let termsSpacing: CGFloat = 4
    }

    // MARK: - Properties
    let headerView: NavigationBar = {
        let view = NavigationBar(type: .arrowLeft)
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
        label.attributedText = .makeStyledString(font: .h_xxxl_b, text: "필수약관에 동의해주세요")
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_m, text: "메랜사를 더 편하게 즐기기 위해 필요한 항목이에요", color: .neutral700)
        return label
    }()

    public let totalAgreeButton: CheckBoxButton = {
        let button = CheckBoxButton(style: .normal, mainTitle: "전체동의", subTitle: "(선택 약관 포함)")
        return button
    }()

    private let termsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.isUserInteractionEnabled = true
        view.spacing = Constant.termsSpacing
        return view
    }()

    public let ageAgreeButton: CheckBoxButton = {
        let button = CheckBoxButton(style: .listMedium, mainTitle: "(필수) 만 14세 이상", subTitle: nil)
        return button
    }()

    public let serviceTermsAgreeButton: CheckBoxButton = {
        let button = CheckBoxButton(style: .listMedium, mainTitle: "(필수) 메랜사 서비스 이용약관 동의", subTitle: nil)
        return button
    }()

    public let personalInformationAgreeButton: CheckBoxButton = {
        let button = CheckBoxButton(style: .listMedium, mainTitle: "(필수) 개인정보 수집 및 이용 동의", subTitle: nil)
        return button
    }()

    public let marketingAgreeButton: CheckBoxButton = {
        let button = CheckBoxButton(style: .listMedium, mainTitle: "(선택) 마케팅 정보 수신 동의", subTitle: nil)
        return button
    }()

    public let bottomButton: CommonButton = {
        let button = CommonButton(style: .normal, title: "다음", disabledTitle: "다음")
        return button
    }()

    // MARK: - init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension TermsAgreementView {
    func addViews() {
        addSubview(headerView)
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(totalAgreeButton)
        addSubview(bottomButton)
        addSubview(termsStackView)
        termsStackView.addArrangedSubview(ageAgreeButton)
        termsStackView.addArrangedSubview(serviceTermsAgreeButton)
        termsStackView.addArrangedSubview(personalInformationAgreeButton)
        termsStackView.addArrangedSubview(marketingAgreeButton)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constant.imageTopSpacing)
            make.size.equalTo(Constant.imageSize)
            make.leading.equalToSuperview().inset(Constant.horizontalInset)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(Constant.titleLabelTopSpacing)
            make.height.equalTo(Constant.titleLabelHeight)
            make.leading.equalTo(logoImageView)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.subTitleLabelTopSpacing)
            make.height.equalTo(Constant.subTitleLabelHeight)
            make.leading.equalTo(logoImageView)
        }
        bottomButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.bottomButtonBottomSpacing)
        }
        termsStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalTo(bottomButton.snp.top).offset(Constant.stackViewBottomSpacing)
        }
        totalAgreeButton.snp.makeConstraints { make in
            make.bottom.equalTo(termsStackView.snp.top).offset(Constant.totalButtonBottomSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
    }
}
