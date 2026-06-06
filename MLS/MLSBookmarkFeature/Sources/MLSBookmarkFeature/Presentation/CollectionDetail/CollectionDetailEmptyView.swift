import MLSDesignSystem
import SnapKit
import UIKit

final class CollectionDetailEmptyView: UIView {
    private enum Constant {
        static let imageSize: CGFloat = 220
        static let textSpacing: CGFloat = 10
        static let buttonSpacing: CGFloat = 24
        static let buttonWidth: CGFloat = 186
    }

    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "connectionError")
        return view
    }()

    private let mainLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xl_b, text: "아직 아무것도 없어요!", color: .textColor)
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_s_r, text: "북마크해서 추가해보세요.", color: .neutral600)
        return label
    }()

    let bookmarkButton = CommonButton(style: .normal, title: "북마크하러 가기", disabledTitle: nil)

    init() {
        super.init(frame: .zero)
        addSubview(imageView)
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(bookmarkButton)

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageSize)
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.center.equalToSuperview()
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(Constant.textSpacing)
            make.centerX.equalToSuperview()
        }

        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(Constant.buttonSpacing)
            make.width.equalTo(Constant.buttonWidth)
            make.centerX.equalToSuperview()
        }

        backgroundColor = .clearMLS
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
