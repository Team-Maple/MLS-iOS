import UIKit

import DesignSystem

import RxSwift
import SnapKit

public class CheckBoxButtonListSmallCell: UICollectionViewCell {

    private let checkBoxButton: CheckBoxButton = {
        let button = CheckBoxButton(style: .listSmall, mainTitle: nil, subTitle: nil)
        button.isUserInteractionEnabled = false
        return button
    }()

    private var disposeBag = DisposeBag()

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
            checkBoxButton.isSelected = isSelected
        }
    }
}

// MARK: - SetUp
private extension CheckBoxButtonListSmallCell {
    func addViews() {
        contentView.addSubview(checkBoxButton)
    }

    func setupConstraints() {
        checkBoxButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
    }
}

public extension CheckBoxButtonListSmallCell {
    func inject(title: String?) {
        checkBoxButton.mainTitle = title
    }
}
