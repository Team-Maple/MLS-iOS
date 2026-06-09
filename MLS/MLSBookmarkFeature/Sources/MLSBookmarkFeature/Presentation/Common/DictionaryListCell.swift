import UIKit

import MLSBookmarkFeatureInterface
import MLSCore
import MLSDesignSystem
import MLSDictionaryFeatureInterface

import SnapKit

final class DictionaryListCell: UICollectionViewCell {
    private var onBookmarkTapped: (() -> Void)?

    let cellView = CardList()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        onBookmarkTapped = nil
        cellView.onIconTapped = nil
        cellView.setMainText(text: "")
        cellView.setSubText(text: nil)
        cellView.setSelected(isSelected: false)
    }
}

extension DictionaryListCell {
    struct Input {
        let type: DictionaryItemType
        let mainText: String
        let subText: String?
        let imageUrl: String
        let isBookmarked: Bool
    }

    func inject(
        type: CardList.CardListType,
        input: Input,
        indexPath: IndexPath,
        collectionView: UICollectionView,
        isMap: Bool = false,
        onBookmarkTapped: @escaping () -> Void
    ) {
        cellView.setType(type: type)
        cellView.setImage(image: UIImage(), backgroundColor: input.type.backgroundColor)

        if let url = URL(string: input.imageUrl) {
            ImageLoader.shared.loadImage(url: url) { [weak self] image in
                guard let self else { return }
                if let currentIndex = collectionView.indexPath(for: self), currentIndex == indexPath {
                    if isMap {
                        self.cellView.setMapImage(image: image ?? UIImage(), backgroundColor: input.type.backgroundColor)
                    } else {
                        self.cellView.setImage(image: image ?? UIImage(), backgroundColor: input.type.backgroundColor)
                    }
                }
            }
        }

        cellView.setMainText(text: input.mainText)
        cellView.setSubText(text: input.subText)
        cellView.setSelected(isSelected: input.isBookmarked)
        self.onBookmarkTapped = onBookmarkTapped
        cellView.onIconTapped = { [weak self] in
            self?.onBookmarkTapped?()
        }
    }

    func updateBookmarkState(isBookmarked: Bool) {
        cellView.setSelected(isSelected: isBookmarked)
    }
}

extension DictionaryItemType {
    var backgroundColor: UIColor {
        switch self {
        case .item: .listItem
        case .monster: .listMonster
        case .map: .listMap
        case .npc: .listNPC
        case .quest: .listQuest
        }
    }
}
