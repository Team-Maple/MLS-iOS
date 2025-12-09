import UIKit

import DesignSystem

import SnapKit

public enum EmptyViewType {
    case dictionary
    case bookmark
}

public final class DataEmptyView: UIView {
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
    public init(type: EmptyViewType) {
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
private extension DataEmptyView {
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

    func configureUI(type: EmptyViewType) {
        backgroundColor = .neutral100

        switch type {
        case .dictionary:
            imageView.image = DesignSystemAsset.image(named: "noResult")
            mainLabel.attributedText = .makeStyledString(
                font: .b_m_r,
                text: "검색 결과가 없습니다."
            )

            subLabel.isHidden = true
            button.isHidden = true
        case .bookmark:
            imageView.image = DesignSystemAsset.image(named: "noShowList")
            mainLabel.attributedText = .makeStyledString(
                font: .h_xl_b,
                text: "아직 아무것도 없어요!"
            )

            subLabel.attributedText = .makeStyledString(
                font: .cp_s_r,
                text: "북마크해서 추가해보세요.",
                color: .neutral600
            )

            button.updateTitle(title: "북마크하러 가기")
        }
    }
}
