import UIKit

import DesignSystem

import SnapKit

public class TapButtonCell: UICollectionViewCell {

    public let button: TapButton = {
        let button = TapButton()
        return button
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
            button.isSelected = isSelected
        }
    }
}

// MARK: - SetUp
private extension TapButtonCell {
    func addViews() {
        contentView.addSubview(button)
    }

    func setupConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() { }
}

public extension TapButtonCell {
    func inject(title: String?) {
        button.text = title
        button.isUserInteractionEnabled = false
    }
}
