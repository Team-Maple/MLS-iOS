import UIKit

import DesignSystem

import SnapKit

public class MonsterFilterBottomSheetView: UIView {
    private enum Constant {
        static let horizontalInset: CGFloat = 16
        static let buttonSpacing: CGFloat = 8
        static let buttonSuperViewSize = UIScreen.main.bounds.width - (Constant.horizontalInset * 2) - buttonSpacing
        static let buttonStackViewTopMargin: CGFloat = 12
        static let buttonStackViewBottomMargin: CGFloat = 16
        static let dividerHeight = 1
        static let itemBottomSpacing = 31
    }

    // MARK: - Properties
    let tapGesture = UITapGestureRecognizer()
    var lowerLevel: CGFloat
    var upperLevel: CGFloat

    // MARK: - Components
    let header: Header = {
        let header = Header(style: .filter, title: "필터")
        return header
    }()

    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_b, text: "레벨", alignment: .left)
        return label
    }()

    let levelRangeView: FilterLevelSectionView

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral200
        return view
    }()

    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()

    public let clearButton: CommonButton = {
        let button = CommonButton(style: .border, title: "초기화", disabledTitle: nil)
        return button
    }()

    public let applyButton: CommonButton = {
        let button = CommonButton(style: .normal, title: "적용하기", disabledTitle: nil)
        return button
    }()

    // MARK: - init
    init(lowerLevel: CGFloat, upperLevel: CGFloat) {
        self.lowerLevel = lowerLevel
        self.upperLevel = upperLevel
        self.levelRangeView = FilterLevelSectionView(initialLowerValue: lowerLevel, initialUpperValue: upperLevel)
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension MonsterFilterBottomSheetView {
    func addViews() {
        addSubview(header)
        addSubview(sectionTitleLabel)
        addSubview(levelRangeView)
        addSubview(dividerView)
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(clearButton)
        buttonStackView.addArrangedSubview(applyButton)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview()
        }
        sectionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(Constant.itemBottomSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        levelRangeView.snp.makeConstraints { make in
            make.top.equalTo(sectionTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(levelRangeView.snp.bottom).offset(Constant.itemBottomSpacing)
            make.height.equalTo(Constant.dividerHeight)
            make.horizontalEdges.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.top).offset(Constant.buttonStackViewTopMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.buttonStackViewBottomMargin)
        }
        clearButton.snp.makeConstraints { make in
            make.width.equalTo(Constant.buttonSuperViewSize * 0.3)
        }
    }

    func configureUI() {
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
}
