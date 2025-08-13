import UIKit

import DesignSystem

import RxSwift
import SnapKit

public class BadgeCell: UICollectionViewCell {

    public var badge = Badge(style: .currentQuest)

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
private extension BadgeCell {
    func addViews() {
        contentView.addSubview(badge)
    }

    func setupConstraints() {
        badge.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() { }
}

public extension BadgeCell {
    func inject(name: String) {
        badge.update(style: .element(name))
    }
}
