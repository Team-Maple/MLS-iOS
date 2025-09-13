import UIKit

import DesignSystem
import DomainInterface

import SnapKit

public final class SetProfileView: UIView {
    // MARK: - Type
    enum Constant {
        static let buttonSize: CGFloat = 44
        static let headerViewHeight: CGFloat = 44
        static let imageViewTopMargin: CGFloat = 20
        static let imageSize: CGFloat = 104
        static let setImageIconSize: CGFloat = 24
        static let nameTopMargin: CGFloat = 12
        static let nameBottomMargin: CGFloat = 64
        static let backgroudViewTopInset: CGFloat = 20
        static let backgroudViewHorizontalInset: CGFloat = 16
        static let cancelTextViewBottomMargin: CGFloat = 10
        static let contentViewInset: CGFloat = 20
        static let textSpacing: CGFloat = 28
        static let platformSpacing: CGFloat = 5
        static let platformIconSize: CGFloat = 26
        static let logoutBottomMargin: CGFloat = 11
        static let nickNameTopMargin: CGFloat = 40
        static let nickNameHorizontalMargin: CGFloat = 33
        static let radius: CGFloat = 16
    }

    // MARK: - Properties
    var onCancelTap: (() -> Void)?
    
    // MARK: - Components
    // shared
    private lazy var headerView: UIView = {
        let view = UIView()
        
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(editButton)
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(Constant.buttonSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(Constant.buttonSize)
        }
        
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "arrowBack"), for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_b, text: "프로필 설정")
        return label
    }()
    
    private let editButton = UIButton()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        
        view.addSubview(setImageButton)
        
        setImageButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.size.equalTo(Constant.setImageIconSize)
        }
        
        return view
    }()
    
    private let setImageButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "plusIcon"), for: .normal)
        return button
    }()
    
    private let nameLabel = UILabel()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledUnderlinedString(font: .b_s_r, text: "로그아웃", color: .neutral600), for: .normal)
        return button
    }()
    
    private let cancelTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        
        let text = "메이플랜드사전을 탈퇴하려면 여기를 눌러주세요"
        let attributed = NSMutableAttributedString(string: text)
        
        let fullRange = NSRange(text.startIndex..<text.endIndex, in: text)
        attributed.addAttribute(.font, value: UIFont.korFont(style: .regular, size: 12)!, range: fullRange)
        attributed.addAttribute(.foregroundColor, value: UIColor.neutral500, range: fullRange)
        
        if let range = text.range(of: "여기") {
            let nsRange = NSRange(range, in: text)
            attributed.addAttribute(.link, value: "cancel", range: nsRange)
            attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        }
        
        textView.attributedText = attributed
        
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.neutral500,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        return textView
    }()
    
    // normal
    private lazy var backgroudView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral100
        
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.backgroudViewTopInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.backgroudViewHorizontalInset)
        }
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteMLS
        view.layer.cornerRadius = Constant.radius
        
        view.addSubview(infoLabel)
        view.addSubview(accountLabel)
        view.addSubview(platformIconView)
        view.addSubview(platformLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Constant.contentViewInset)
        }
        
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(Constant.textSpacing)
            make.leading.bottom.equalToSuperview().inset(Constant.contentViewInset)
        }
        
        platformIconView.snp.makeConstraints { make in
            make.leading.equalTo(accountLabel.snp.trailing)
            make.centerY.equalTo(accountLabel)
            make.size.equalTo(Constant.platformIconSize)
        }
        
        platformLabel.snp.makeConstraints { make in
            make.leading.equalTo(platformIconView.snp.trailing).offset(Constant.platformSpacing)
            make.trailing.equalToSuperview().inset(Constant.contentViewInset)
            make.centerY.equalTo(accountLabel)
        }
        
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_b, text: "가입 정보")
        return label
    }()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_m_r, text: "가입 계정", alignment: .left)
        return label
    }()
    
    private let platformIconView = UIImageView()
    private let platformLabel = UILabel()
    
    // setEdit
    private let nickNameInputBox: InputBox = {
        let box = InputBox(label: "닉네임", placeHodler: "한글 2~15자 입력해주세요.")
        box.label.attributedText = .makeStyledString(font: .cp_s_r, text: "닉네임", color: .textColor)
        return box
    }()
    private let countLabel = UILabel()

    // MARK: - init
    public init() {
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
private extension SetProfileView {
    func addViews() {
        addSubview(headerView)
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(backgroudView)
        addSubview(nickNameInputBox)
        addSubview(logoutButton)
        addSubview(cancelTextView)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constant.headerViewHeight)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constant.imageViewTopMargin)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageSize)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constant.nameTopMargin)
            make.centerX.equalToSuperview()
        }
        
        backgroudView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constant.nameBottomMargin)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        nickNameInputBox.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constant.nickNameTopMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.nickNameHorizontalMargin)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        cancelTextView.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(Constant.logoutBottomMargin)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constant.cancelTextViewBottomMargin)
        }
    }
    
    func configureUI() {
        backgroundColor = .whiteMLS
        cancelTextView.delegate = self
    }
}

extension SetProfileView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "cancel" {
            onCancelTap?()
            return false
        }
        return true
    }
}

public extension SetProfileView {
    enum SetProfileState {
        case normal
        case edit
    }
    
    func setState(state: SetProfileState) {
        switch state {
        case .normal:
            editButton.setAttributedTitle(.makeStyledString(font: .btn_m_r, text: "수정"), for: .normal)
            nameLabel.isHidden = false
            backgroudView.isHidden = false
            nickNameInputBox.isHidden = true
            setImageButton.isHidden = true
        case .edit:
            editButton.setAttributedTitle(.makeStyledString(font: .btn_m_r, text: "완료"), for: .normal)
            nameLabel.isHidden = true
            backgroudView.isHidden = true
            nickNameInputBox.isHidden = false
            setImageButton.isHidden = false
        }
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    func setName(name: String) {
        nameLabel.attributedText = .makeStyledString(font: .sub_l_b, text: name)
    }
    
    func setPlatform(platform: LoginPlatform) {
        switch platform {
        case .kakao:
            platformLabel.attributedText = .makeStyledString(font: .b_m_r, text: "카카오")
            platformIconView.image = DesignSystemAsset.image(named: "kakaoImage")
        case .apple:
            platformLabel.attributedText = .makeStyledString(font: .b_m_r, text: "애플")
            platformIconView.image = DesignSystemAsset.image(named: "kakaoImage")
        }
    }
}
