import UIKit

import BookmarkFeatureInterface
import DesignSystem
import DomainInterface

import SnapKit

public final class AddCollectionView: UIView {
    // MARK: - Type
    enum Constant {
        static let radius: CGFloat = 8
        static let titleTopMargin: CGFloat = 20
        static let imageViewSize: CGFloat = 40
        static let iconInset: CGFloat = 8
        static let inputInset: CGFloat = 10
        static let inputSpacing: CGFloat = 16
        static let inputHeight: CGFloat = 60
        static let horizontalMargin: CGFloat = 16
        static let nameLabelTopMargin: CGFloat = 20
        static let nameLabelBottomMargin: CGFloat = 14
        static let buttonTopMargin: CGFloat = 68
        static let buttonBottomMargin: CGFloat = 10
    }

    // MARK: - Properties
    public var addButtonBottomConstraint: Constraint?

    // MARK: - Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xl_b, text: "컬렉션", alignment: .left)
        return label
    }()

    public let backButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "largeX"), for: .normal)
        return button
    }()

    private lazy var inputTextView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral100
        view.layer.cornerRadius = Constant.radius
        view.addSubview(imageView)
        view.addSubview(inputTextField)

        imageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(Constant.inputInset)
            make.size.equalTo(Constant.imageViewSize)
        }

        inputTextField.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(Constant.inputSpacing)
        }
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_sb, text: "컬렉션 이름 입력", alignment: .left)
        return label
    }()

    private lazy var imageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constant.radius
        view.backgroundColor = .neutral200
        view.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalTo(view).inset(Constant.iconInset)
        }
        return view
    }()

    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "bookmark")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .neutral300
        return view
    }()

    public let inputTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clearMLS
        textField.tintColor = .primary300
        textField.textAlignment = .left
        textField.font = .korFont(style: .semiBold, size: 14)
        textField.attributedPlaceholder = NSAttributedString(
            string: "컬렉션 이름을 입력해주세요 (최대 18자)",
            attributes: [.foregroundColor: UIColor.neutral500]
        )
        return textField
    }()

    private let errorMessage = ErrorMessage(message: "폴더명은 18자 이하로 입력해주세요.")

    public let completeButton = CommonButton(style: .normal, title: "완료", disabledTitle: "완료")

    // MARK: - init
    public init() {
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
private extension AddCollectionView {
    func addViews() {
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(nameLabel)
        addSubview(inputTextView)
        addSubview(errorMessage)
        addSubview(completeButton)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constant.titleTopMargin)
            $0.leading.equalToSuperview().inset(Constant.horizontalMargin)
        }

        backButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(Constant.horizontalMargin)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.nameLabelTopMargin)
            $0.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
        }

        inputTextView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constant.nameLabelBottomMargin)
            $0.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
            $0.height.equalTo(Constant.inputHeight)
        }

        errorMessage.snp.makeConstraints {
            $0.bottom.equalTo(completeButton.snp.top).offset(-Constant.buttonBottomMargin)
            $0.centerX.equalToSuperview()
        }

        completeButton.snp.makeConstraints {
            $0.top.equalTo(inputTextView.snp.bottom).offset(Constant.buttonTopMargin)
            $0.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
            addButtonBottomConstraint = $0.bottom.equalToSuperview().inset(Constant.buttonBottomMargin).constraint
        }
    }
}

extension AddCollectionView {
    func setError(isError: Bool) {
        errorMessage.isHidden = !isError
    }

    func setButtonEnabled(isEnabled: Bool) {
        completeButton.isEnabled = isEnabled
    }

    func checkIsEmptyCollection(collection: CollectionResponse?) {
        if collection != nil {
            nameLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: "컬렉션 이름 수정", alignment: .left)
        }
    }

    func updateTextField(text: String?) {
        if let text = text {
            inputTextField.attributedText = .makeStyledString(font: .b_s_sb, text: text, color: .textColor, alignment: .left)
        }
    }
}
