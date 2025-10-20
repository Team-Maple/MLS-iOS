import UIKit

import DesignSystem

import SnapKit

final class OnBoardingNotificationSheetView: UIView {
    private enum Constant {
        static let inset: CGFloat = 16
        static let spacing: CGFloat = 14
        static let buttonTopMargin: CGFloat = 20
    }

    // MARK: - Properties
    let header: Header = {
        let header = Header(style: .filter, title: "신규 이벤트 알림 설정")
        return header
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Constant.spacing
        return view
    }()

    let notificationToggleBox = ToggleBox(text: "알림 설정")
    let applyButton = CommonButton(style: .normal, title: "적용", disabledTitle: nil)
    let settingButton = CommonButton(style: .normal, title: "변경하기", disabledTitle: nil)
    let skipButton = CommonButton(style: .border, title: "나중에 하기", disabledTitle: nil)

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
private extension OnBoardingNotificationSheetView {
    func addViews() {
        addSubview(header)
        addSubview(descriptionLabel)
        addSubview(buttonStackView)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.inset)
            make.horizontalEdges.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(Constant.spacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.inset)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constant.buttonTopMargin)
            make.horizontalEdges.bottom.equalToSuperview().inset(Constant.inset)
        }
    }

    func configureUI() {
        notificationToggleBox.toggle.isOn = true
    }
}

// MARK: - Methods
extension OnBoardingNotificationSheetView {
    func setUI(isAgree: Bool) {
        buttonStackView.arrangedSubviews.forEach { view in
            buttonStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        descriptionLabel.attributedText = .makeStyledString(font: .cp_s_r, text: isAgree ? "메이플랜드 이벤트 소식을\n푸시 알림으로 빠르게 받아보세요." : "기기 알림 설정을 변경해야 이벤트 소식을 받을 수 있어요.", color: .neutral700, alignment: .left)
        if isAgree {
            buttonStackView.addArrangedSubview(notificationToggleBox)
            buttonStackView.addArrangedSubview(applyButton)
        } else {
            buttonStackView.addArrangedSubview(settingButton)
            buttonStackView.addArrangedSubview(skipButton)
        }
    }
}
