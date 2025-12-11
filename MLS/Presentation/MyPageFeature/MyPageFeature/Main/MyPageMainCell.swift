import UIKit

import BaseFeature
import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

public final class MyPageMainCell: UICollectionViewCell {
    // MARK: - Type
    enum Constant {
        static let imageSize: CGFloat = 104
        static let spacingBetweenImageAndLabel: CGFloat = 12
        static let spacingBetweenLabelAndButton: CGFloat = 16
        static let buttonHeight: CGFloat = 44
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 20
        static let radius: CGFloat = 42
    }

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    public var onSetProfileTap: (() -> Void)?

    // MARK: - Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.radius
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    public let setProfileButton = CommonButton(style: .normal, title: "프로필 설정", disabledTitle: nil)

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, setProfileButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Constant.spacingBetweenImageAndLabel
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        configureUI()
        bindButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - Setup
private extension MyPageMainCell {
    func addViews() {
        addSubview(contentStackView)
    }

    func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constant.verticalInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }

        imageView.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
        }

        setProfileButton.snp.remakeConstraints { make in
            make.height.equalTo(Constant.buttonHeight)
            make.horizontalEdges.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
    }

    func bindButton() {
        setProfileButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.onSetProfileTap?()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Public
public extension MyPageMainCell {
    struct Input {
        let imageUrl: String
        let name: String
        let isLogin: Bool
    }

    func inject(input: Input) {
        if input.isLogin {
            imageView.isHidden = false
            ImageLoader.shared.loadImage(stringURL: input.imageUrl) { [weak self] image in
                self?.imageView.image = image
            }
            nameLabel.attributedText = .makeStyledString(font: .sub_l_b, text: input.name)
            contentStackView.spacing = Constant.spacingBetweenImageAndLabel
            setProfileButton.updateTitle(title: "프로필 설정")
        } else {
            imageView.isHidden = true
            nameLabel.attributedText = .makeStyledString(
                font: .b_s_m,
                text: "로그인 후 이벤트 실시간 알림과 북마크\n그리고 최적화된 검색 서비스를 이용해보세요",
                color: .neutral500
            )
            contentStackView.spacing = Constant.spacingBetweenLabelAndButton
            setProfileButton.updateTitle(title: "로그인 하기")
        }
    }
}
