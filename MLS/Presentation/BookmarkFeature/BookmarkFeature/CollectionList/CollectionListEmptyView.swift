import UIKit

import DesignSystem

import SnapKit

final class CollectionListEmptyView: UIView {
    // MARK: - Type
    enum Constant {
        static let topInset: CGFloat = 60
        static let imageSize: CGFloat = 220
        static let textSpacing: CGFloat = 10
    }

    // MARK: - Components
    public let imageView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "fabHint")
        return view
    }()

    private let mainLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xl_b, text: "첫 컬렉션을 만들어보세요", color: .textColor)
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .cp_s_r, text: "컬렉션을 만들면 북마크한 리스트틀\n내 취향대로 정리할 수 있어요.", color: .neutral600)
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension CollectionListEmptyView {
    func addViews() {
        addSubview(imageView)
        addSubview(mainLabel)
        addSubview(subLabel)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.topInset)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageSize)
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalToSuperview()
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(Constant.textSpacing)
            make.centerX.equalToSuperview()
        }
    }

    func configureUI() {
//        backgroundColor = .clearMLS
    }
}
