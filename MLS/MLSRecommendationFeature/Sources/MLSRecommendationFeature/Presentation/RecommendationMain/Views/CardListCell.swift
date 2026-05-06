import UIKit

import MLSDesignSystem

import SnapKit

final class CardListCell: UICollectionViewCell {

    // MARK: - Properties
    let cardView = CardList()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension CardListCell {
    func addViews() {
        contentView.addSubview(cardView)
    }

    func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
