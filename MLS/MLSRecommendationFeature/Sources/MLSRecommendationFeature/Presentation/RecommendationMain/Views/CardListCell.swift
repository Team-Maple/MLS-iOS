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
        setupContstraints()
        configureUI()
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

    func setupContstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() { }
}
