import UIKit

import DesignSystem

import RxSwift
import SnapKit

public class TagChipCell: UICollectionViewCell {

    public let button: TagChip = {
        let button = TagChip(style: .normal, text: "")
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        configureUI()
    }

    public var disposeBag = DisposeBag()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}

// MARK: - SetUp
private extension TagChipCell {
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

public extension TagChipCell {
    func inject(title: String?) {
        button.text = title ?? ""
        button.titleLabel?.numberOfLines = 1
    }
}
