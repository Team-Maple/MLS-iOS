import UIKit

import DesignSystem
import DomainInterface

final class DictionaryListCell: UICollectionViewCell {
    // MARK: - Properties
    private var onBookmarkTapped: (() -> Void)?

    // MARK: - Components
    public let cellView = CardList()

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
private extension DictionaryListCell {
    func addViews() {
        contentView.addSubview(cellView)
    }

    func setupContstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DictionaryListCell {
    struct Input {
        let type: DictionaryItemType
        let mainText: String
        let subText: String
        let image: UIImage
        let isBookmarked: Bool
    }

    func inject(type: CardList.CardListType, input: Input, onBookmarkTapped: @escaping () -> Void) {
        cellView.setType(type: type)
        cellView.setImage(image: input.image, backgroundColor: input.type.backgroundColor)
        cellView.setMainText(text: input.mainText)
        cellView.setSubText(text: input.subText)
        cellView.setSelected(isSelected: input.isBookmarked)
        self.onBookmarkTapped = onBookmarkTapped
        cellView.onIconTapped = { [weak self] _ in
            self?.onBookmarkTapped?()
        }
    }
}

public extension DictionaryItemType {
    var backgroundColor: UIColor {
        switch self {
        case .item:
            .listItem
        case .monster:
            .listMonster
        case .map:
            .listMap
        case .npc:
            .listNPC
        case .quest:
            .listQuest
        }
    }
}
