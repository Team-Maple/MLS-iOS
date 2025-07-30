import UIKit

import DesignSystem

import SnapKit

final class DictionaryListEmptyView: UIView {
    // MARK: - Type
    enum Constant {
        static let imageSize: CGFloat = 220
        static let topInset: CGFloat = 12
        static let spacing: CGFloat = 4
    }

    // MARK: - Components
    public let imageView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "noResult")
        return view
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .body, text: "검색 결과가 없습니다.")
        return label
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - SetUp
private extension DictionaryListEmptyView {
    func addViews() {
        addSubview(imageView)
        addSubview(textLabel)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.topInset)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageSize)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constant.spacing)
            make.centerX.equalToSuperview()
        }
    }
}
