import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

public class FilterLevelSectionCell: UICollectionViewCell {
    public let levelSectionView: FilterLevelSectionView = {
        let view = FilterLevelSectionView()
        return view
    }()

    public var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        levelSectionView.disposeBag = DisposeBag()
        levelSectionView.bind()
    }
}

// MARK: - SetUp
private extension FilterLevelSectionCell {
    func addViews() {
        contentView.addSubview(levelSectionView)
    }

    func setupConstraints() {
        levelSectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
