import UIKit

import DesignSystem

import SnapKit
import RxCocoa

final class SortedBottomSheetView: UIView {

    private enum Constant {
        static let defaultInset: CGFloat = 16
        static let buttonSpacing: CGFloat = 8
        static let buttonSuperViewSize = UIScreen.main.bounds.width - (Constant.defaultInset * 2) - buttonSpacing
        static let buttonStackViewTopMargin: CGFloat = 12
        static let buttonStackViewBottomMargin: CGFloat = 16
        static let dividerHeight = 1
        static let itemBottomSpacing = 31
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

    // MARK: - init
    init() {
        super.init(frame: .zero)
        
        addViews()
        setupConstraints()
    }
    
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
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview()
        }
        sortedStackView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview()
        }
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(sortedStackView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview().inset(Constant.defaultInset)
        }
    }
}
