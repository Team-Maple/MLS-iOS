import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

open class CharacterInputView: UIView {
    // MARK: - Type
    public enum Constant {
        public static let horizontalInset: CGFloat = 16
        public static let verticalInset: CGFloat = 40
        static let verticalSpacing: CGFloat = 28
        static let horizontalSpacing: CGFloat = 8
        public static let bottomInset: CGFloat = 16
        static let messageSpacing: CGFloat = 8
        static let boxInset: CGFloat = (horizontalInset + (horizontalSpacing / 2)) / 2
    }

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    public var nextButtonBottomConstraint: Constraint?

    // MARK: - Components
    public let descriptionLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xxl_b, text: "현재 레벨과 직업을\n입력해주세요.", alignment: .left)
        label.numberOfLines = 2
        return label
    }()

    public let inputBox: InputBox = {
        let box = InputBox(label: "레벨", placeHodler: "1~200")
        box.textField.keyboardType = .numberPad
        return box
    }()

    public let dropDownBox = DropDownBox(label: "직업", placeHodler: "선택", items: [])

    public let errorMessage = ErrorMessage(message: "1에서 200까지 숫자만 입력해주세요")

    public let nextButton = CommonButton(style: .normal, title: "다음", disabledTitle: "다음")

    // MARK: - init
    public init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
        setGesture()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension CharacterInputView {
    func addViews() {
        addSubview(descriptionLabel)
        addSubview(inputBox)
        addSubview(dropDownBox)
        addSubview(errorMessage)
        addSubview(nextButton)
    }

    func setupConstraints() {
        inputBox.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constant.verticalSpacing)
            make.leading.equalToSuperview().inset(Constant.horizontalInset)
            make.width.equalToSuperview().multipliedBy(0.5).inset(Constant.boxInset)
        }

        dropDownBox.snp.makeConstraints { make in
            make.top.equalTo(inputBox)
            make.leading.equalTo(inputBox.snp.trailing).offset(Constant.horizontalSpacing)
            make.trailing.equalToSuperview().inset(Constant.horizontalInset)
            make.width.equalToSuperview().multipliedBy(0.5).inset(Constant.boxInset)
        }

        errorMessage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(errorMessage.snp.bottom).offset(Constant.messageSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            nextButtonBottomConstraint = make.bottom.equalToSuperview().inset(Constant.bottomInset).constraint
        }
    }

    func configureUI() {
        inputBox.textField.delegate = self
        errorMessage.isHidden = true
    }

    /// inputBox를 제외한 영역 선택시 키보드 제거
    func setGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)

        Observable.merge(
            tapGesture.rx.event.map { $0.location(in: self) }.asObservable()
        )
        .withUnretained(self)
        .filter { owner, location in
            !owner.inputBox.frame.contains(location)
        }
        .subscribe { owner, _ in
            owner.inputBox.textField.resignFirstResponder()
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - UITextFieldDelegate
extension CharacterInputView: UITextFieldDelegate {
    /// textField의 붙여넣기 기능 차단
    /// - Parameters:
    ///   - action: 선택자를 나타내는 selector
    ///   - sender: 동작을 트리거한 객체
    /// - Returns: 붙여넣기가 허용되면 true / 허용되지 않으면 false
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
