import UIKit

import DesignSystem

public final class MyPageMainCell: UICollectionViewCell {
    // MARK: - Type
    struct Constant {
        static let imageSize: CGFloat = 104
        static let labelTopMargin: CGFloat = 12
        static let buttonTopMargin: CGFloat = 16
        static let buttonHight: CGFloat = 44
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 20
    }
    
    // MARK: - Components
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    public let setProfileButton = CommonButton(style: .normal, title: "프로필 설정", disabledTitle: nil)

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
        setupContstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension MyPageMainCell {
    func addViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(setProfileButton)
    }

    func setupContstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.verticalInset)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageSize)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constant.labelTopMargin)
            make.centerX.equalToSuperview()
        }
        
        setProfileButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constant.buttonTopMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.verticalInset)
            make.height.equalTo(Constant.buttonHight)
        }
    }
    
    func configureUI() {
        backgroundColor = .whiteMLS
    }
}

extension MyPageMainCell {
    public struct Input {
        let image: UIImage
        let name: String
    }

    public func inject(input: Input) {
        imageView.image = input.image
        nameLabel.attributedText = .makeStyledString(font: .sub_l_b, text: input.name)
    }
}
