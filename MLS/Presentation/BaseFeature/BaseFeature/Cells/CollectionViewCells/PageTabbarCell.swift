import UIKit

import DesignSystem

import SnapKit

public class PageTabbarCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.textColor = .neutral600
        return label
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .textColor
        view.isHidden = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isSelected: Bool {
        didSet {
            let font: UIFont? = isSelected ? .subTitleBold : .caption
            let textColor: UIColor? = isSelected ? .textColor : .neutral600
            titleLabel.font = font
            titleLabel.textColor = textColor
            indicatorView.isHidden = !isSelected
        }
    }
}

// MARK: - SetUp
private extension PageTabbarCell {
    func addViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(indicatorView)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(2)
        }
    }

    func configureUI() { }
}

public extension PageTabbarCell {
    func configure(title: String?) {
        titleLabel.text = title
    }
}
