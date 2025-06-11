import UIKit

import DesignSystem

class PageTabCell: UICollectionViewCell {
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
//            titleLabel.textColor = isSelected ? .textColor : .neutral600
            titleLabel.attributedText = .makeStyledString(font: isSelected ? .subTitleBold : .body, text: title, color: isSelected ? .textColor : .neutral600)
            underLineView.isHidden = !isSelected
        }
    }
    
    private var title: String?
    
    // MARK: - Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        return label
    }()
    
    private let underLineView: DividerView = {
        let view = DividerView()
        view.backgroundColor = .textColor
        return view
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setupContstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension PageTabCell {
    func addViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(underLineView)
    }

    func setupContstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
    }
}

extension PageTabCell {
    func inject(input: String) {
        title = input
        titleLabel.attributedText = .makeStyledString(font: isSelected ? .subTitleBold : .body, text: title, color: isSelected ? .textColor : .neutral600)
    }
}
