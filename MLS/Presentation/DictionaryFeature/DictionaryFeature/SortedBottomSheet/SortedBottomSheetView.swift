import UIKit

import DesignSystem

import SnapKit

final class SortedBottomSheetView: UIView {
    private enum Constant {
        static let defaultInset: CGFloat = 16
        static let stackViewTopInset = 14
    }

    // MARK: - Properties
    let header: Header = {
        let header = Header(style: .filter, title: "정렬")
        return header
    }()

    let sortedStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()

    let applyButton: CommonButton = {
        let button = CommonButton(style: .normal, title: "적용", disabledTitle: nil)
        return button
    }()

    var sortedButtons: [CheckBoxButton] = []

    // MARK: - init
    init() {
        super.init(frame: .zero)

        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension SortedBottomSheetView {
    func addViews() {
        addSubview(header)
        addSubview(sortedStackView)
        addSubview(applyButton)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.defaultInset)
            make.horizontalEdges.equalToSuperview()
        }
        sortedStackView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(Constant.stackViewTopInset)
            make.horizontalEdges.equalToSuperview()
        }
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(sortedStackView.snp.bottom).offset(Constant.defaultInset)
            make.horizontalEdges.bottom.equalToSuperview().inset(Constant.defaultInset)
        }
    }
}
