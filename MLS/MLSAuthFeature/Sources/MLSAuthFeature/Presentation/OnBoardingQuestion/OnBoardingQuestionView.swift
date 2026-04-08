import UIKit

import DesignSystem

import SnapKit

public final class OnBoardingQuestionView: OnBoardingBaseView {
    // MARK: - Type
    private enum Constant {
        static let horizontalInset = 16
        static let verticalInset = 16
        static let imgSize = 220
        static let resizeCenterY = 70
    }

    // MARK: - Components
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "questionNotify")
        return view
    }()

    private let boldTextLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xxxl_b, text: "효율적인 메이플랜드 플레이를\n위해 몇가지만 물어볼게요")
        label.numberOfLines = 2
        return label
    }()

    private let regularTeextLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_m_r, text: "나도 예티를 잡을 수 있을까?", color: .neutral700)
        return label
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.addSubview(imageView)
        view.addSubview(boldTextLabel)
        view.addSubview(regularTeextLabel)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imgSize)
        }

        boldTextLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }

        regularTeextLabel.snp.makeConstraints { make in
            make.top.equalTo(boldTextLabel.snp.bottom).offset(Constant.verticalInset)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        return view
    }()

    public let nextButton = CommonButton(style: .normal, title: "다음", disabledTitle: "")

    // MARK: - init
    init() {
        super.init(leftButtonIsHidden: true, underlineTextButtonIsHidden: true)
        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension OnBoardingQuestionView {
    func addViews() {
        addSubview(contentView)
        addSubview(nextButton)
    }

    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-Constant.resizeCenterY)
            make.horizontalEdges.equalToSuperview()
        }

        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(Constant.verticalInset)
        }
    }
}
