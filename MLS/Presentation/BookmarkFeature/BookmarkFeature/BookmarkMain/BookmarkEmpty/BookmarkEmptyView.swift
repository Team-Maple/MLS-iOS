import UIKit

import DesignSystem

import SnapKit

final class BookmarkEmptyView: UIView {
    // MARK: - Type
    enum Constant {
        static let imageWidth: CGFloat = 165
        static let imageHeight: CGFloat = 171
        static let imageSpacing: CGFloat = 24
        static let textSpacing: CGFloat = 10
        static let buttonSpacing: CGFloat = 40
        static let buttonWidth: CGFloat = 186
    }

    // MARK: - Components
    public let imageView = UIImageView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()

    private let button = CommonButton(style: .normal, title: "북마크하러 가기", disabledTitle: nil)

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension BookmarkEmptyView {
    func addViews() {
        addSubview(imageView)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(button)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(Constant.imageWidth)
            make.height.equalTo(Constant.imageHeight)
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constant.imageSpacing)
            make.centerX.equalToSuperview()
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(Constant.textSpacing)
            make.centerX.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(Constant.buttonSpacing)
            make.centerX.bottom.equalToSuperview()
            make.width.equalTo(Constant.buttonWidth)
        }
    }
}

extension BookmarkEmptyView {
    func setLabel(isLogin: Bool, buttonAction: @escaping () -> Void) {
        imageView.image = DesignSystemAsset.image(named: isLogin ? "emptyImage" : "emptyImage")
        mainLabel.attributedText = .makeStyledString(
            font: .heading5,
            text: isLogin ? "아직 아무것도 없어요!" : "북마크는 로그인 후 이용 가능해요!"
        )

        subLabel.attributedText = .makeStyledString(
            font: .caption,
            text: isLogin ? "북마크해서 추가해보세요." : "자주 보는 정보, 검색 없이 바로 확인 할 수 있어요."
        )

        button.updateTitle(title: isLogin ? "북마크하러 가기" : "로그인하러 가기")
        button.removeTarget(nil, action: nil, for: .allEvents)
        button.addAction(UIAction { _ in
            buttonAction()
        }, for: .touchUpInside)
    }
}
