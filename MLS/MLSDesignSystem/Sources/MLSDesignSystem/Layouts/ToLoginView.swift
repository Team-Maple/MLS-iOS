import UIKit

import SnapKit

public enum LoginViewType {
    case bookmark
    case recommend

    var mainText: String {
        switch self {
        case .bookmark:
            "북마크는 로그인 후 이용 가능해요!"
        case .recommend:
            "로그인하면 추천 기능이 열려요!"
        }
    }

    var subText: String {
        switch self {
        case .bookmark:
            "자주 보는 정보, 검색 없이 바로 확인 할 수 있어요"
        case .recommend:
            "내 레벨과 직업에 맞춰\n사냥터를 추천받을 수 있어요"
        }
    }
}

public final class ToLoginView: UIView {
    // MARK: - Type
    enum Constant {
        static let imageSize: CGFloat = 220
        static let textSpacing: CGFloat = 10
        static let buttonSpacing: CGFloat = 24
        static let buttonWidth: CGFloat = 186
    }

    // MARK: - Components
    public let imageView = UIImageView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()

    public let button = CommonButton()

    // MARK: - Init
    public init(type: LoginViewType) {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI(type: type)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension ToLoginView {
    func addViews() {
        addSubview(imageView)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(button)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageSize)
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(Constant.textSpacing)
            make.centerX.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(Constant.buttonSpacing)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constant.buttonWidth)
        }
    }

    func configureUI(type: LoginViewType) {
        backgroundColor = .neutral100
        imageView.image = DesignSystemAsset.image(named: "noShowList")
        mainLabel.attributedText = .makeStyledString(
            font: .h_xl_b,
            text: type.mainText
        )

        subLabel.attributedText = .makeStyledString(
            font: .cp_s_r,
            text: type.subText,
            color: .neutral600
        )

        button.updateTitle(title: "로그인하러 가기")
    }
}
