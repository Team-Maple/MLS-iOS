import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

public class FilterLevelSectionView: UIView {
    private enum Constant {
        static let inputBoxWidth: CGFloat = (UIScreen.main.bounds.width - (16 * 2) - dashWidth - (stackViewSpacing * 2)) / 2
        static let dashWidth: CGFloat = 7
        static let stackViewSpacing: CGFloat = 6
        static let sliderTopOffSet: CGFloat = 20
        static let sliderBottomMargin: CGFloat = 12
        static let sliderHeight: CGFloat = 26
    }

    private var isEdit = false

    let leftInputBox: InputBox = {
        let box = InputBox(label: "범위", placeHodler: "1")
        box.textField.keyboardType = .numberPad
        return box
    }()

    private let dashLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_m_r, text: "-")
        return label
    }()

    let rightInputBox: InputBox = {
        let box = InputBox(placeHodler: "200")
        box.textField.keyboardType = .numberPad
        return box
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .bottom
        view.spacing = Constant.stackViewSpacing
        return view
    }()

    public let slider: FilterSlider

    private let lowerLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_s_r, text: "1", color: .neutral500)
        return label
    }()

    private let middleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_s_r, text: "100", color: .neutral500)
        return label
    }()

    private let upperLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_s_r, text: "200", color: .neutral500)
        return label
    }()

    public var disposeBag = DisposeBag()

    public init(initialLowerValue: CGFloat = 1, initialUpperValue: CGFloat = 200) {
        self.slider = FilterSlider(minimumValue: 1, maximumValue: 200, initialLowerValue: initialLowerValue, initialUpperValue: initialUpperValue)
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension FilterLevelSectionView {
    func addViews() {
        addSubview(stackView)

        stackView.addArrangedSubview(leftInputBox)
        stackView.addArrangedSubview(dashLabel)
        stackView.addArrangedSubview(rightInputBox)
        addSubview(slider)
        addSubview(lowerLabel)
        addSubview(middleLabel)
        addSubview(upperLabel)
    }

    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        leftInputBox.snp.makeConstraints { make in
            make.width.equalTo(Constant.inputBoxWidth)
        }
        rightInputBox.snp.makeConstraints { make in
            make.width.equalTo(Constant.inputBoxWidth)
        }
        dashLabel.snp.makeConstraints { make in
            make.height.equalTo(rightInputBox.snp.height)
            make.width.equalTo(Constant.dashWidth)
        }
        slider.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(Constant.sliderTopOffSet)
            make.height.equalTo(Constant.sliderHeight)
            make.horizontalEdges.equalToSuperview()
        }
        lowerLabel.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(Constant.sliderBottomMargin)
            make.bottom.leading.equalToSuperview()
        }
        middleLabel.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(Constant.sliderBottomMargin)
            make.bottom.centerX.equalToSuperview()
        }
        upperLabel.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(Constant.sliderBottomMargin)
            make.bottom.trailing.equalToSuperview()
        }
    }
}

public extension FilterLevelSectionView {
    func bind() {
        slider.lowerValueObservable
            .withUnretained(self)
            .subscribe { owner, value in
                guard !owner.isEdit else { return }
                let lowValue = Int(value)
                owner.leftInputBox.textField.text = value == owner.slider.minimumValue ? "1" : "\(lowValue)"
            }
            .disposed(by: disposeBag)

        slider.upperValueObservable
            .withUnretained(self)
            .subscribe { owner, value in
                guard !owner.isEdit else { return }
                let upperValue = Int(value)
                owner.rightInputBox.textField.text = value == owner.slider.minimumValue ? "200" : "\(upperValue)"
            }
            .disposed(by: disposeBag)

        leftInputBox.textField.rx.text.orEmpty
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, text in
                guard !owner.isEdit, !text.isEmpty else { return }
                if let value = Double(text) {
                    owner.slider.lowerValue = value
                }
            }
            .disposed(by: disposeBag)

        rightInputBox.textField.rx.text.orEmpty
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, text in
                guard !owner.isEdit, !text.isEmpty else { return }
                if let value = Double(text) {
                    owner.slider.upperValue = value
                }
            }
            .disposed(by: disposeBag)

        let leftBoxDidEnd = leftInputBox.textField.rx.controlEvent(.editingDidEnd).asObservable()
        let rightBoxDidEnd = rightInputBox.textField.rx.controlEvent(.editingDidEnd).asObservable()

        Observable.merge([leftBoxDidEnd, rightBoxDidEnd])
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { owner, _ in
                if let leftValue = Double(owner.leftInputBox.textField.text ?? "1"), let rightValue = Double(owner.rightInputBox.textField.text ?? "200") {
                    if leftValue > rightValue {
                        owner.isEdit = true
                        owner.leftInputBox.textField.text = "\(Int(rightValue))"
                        owner.slider.lowerValue = rightValue
                        owner.rightInputBox.textField.text = "\(Int(leftValue))"
                        owner.slider.upperValue = leftValue
                        owner.isEdit = false
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
