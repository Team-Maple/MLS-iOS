import UIKit

import MLSCore
import MLSDesignSystem

import SnapKit

internal final class RecommendationProfileView: UIStackView {
    // MARK: - Type
    private enum Constant {
        static let profileImageViewSize: CGFloat = 100
        static let outerStackViewSpacing: CGFloat = 38
        static let verticalStackViewSpacing: CGFloat = 18
        static let horizontalStackViewSpacing: CGFloat = 12
    }

    // MARK: - Properties
    internal let profileImageView: UIImageView = .init()
    internal let nicknameLabel: UILabel = .init()
    internal let jobLabel: UILabel = .init()
    internal let levelBadge = Badge(style: .element(""))
    internal let editButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledUnderlinedString(font: .korFont(style: .regular, size: 14), text: "수정하기"), for: .normal)
        return button
    }()

    // MARK: - StackView
    private let verticalStackView: UIStackView = .init()
    private let horizontalStackView: UIStackView = .init()

    // MARK: - init
    internal init() {
        super.init(frame: .zero)

        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension RecommendationProfileView {
    func addViews() {
        horizontalStackView.addArrangedSubview(jobLabel)
        horizontalStackView.addArrangedSubview(levelBadge)
        horizontalStackView.addArrangedSubview(editButton)

        verticalStackView.addArrangedSubview(nicknameLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)

        addArrangedSubview(profileImageView)
        addArrangedSubview(verticalStackView)
    }

    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(Constant.profileImageViewSize)
        }
    }

    func configureUI() {
        alignment = .center
        spacing = Constant.outerStackViewSpacing

        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.spacing = Constant.verticalStackViewSpacing

        horizontalStackView.alignment = .center
        horizontalStackView.spacing = Constant.horizontalStackViewSpacing
    }
}

// MARK: - Configure
internal extension RecommendationProfileView {
    func configure(imageURL: String?, nickName: String, job: String, level: Int) {
        ImageLoader.shared.loadImage(stringURL: imageURL) { [weak self] image in
            self?.profileImageView.image = image
        }
        nicknameLabel.attributedText = .makeStyledString(font: .korFont(style: .bold, size: 18), text: nickName)
        jobLabel.attributedText = .makeStyledString(font: .korFont(style: .regular, size: 16), text: job)
        levelBadge.update(style: .element("Lv.\(level)"))
    }
}
