import UIKit

import DesignSystem
import DomainInterface

public final class DictionaryListCell: UICollectionViewCell {
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
    public struct Input {
        let type: DictionaryItemType
        let mainText: String
        let subText: String
        let image: UIImage
        let isBookmarked: Bool
        
        public init(type: DictionaryItemType, mainText: String, subText: String, image: UIImage, isBookmarked: Bool) {
            self.type = type
            self.mainText = mainText
            self.subText = subText
            self.image = image
            self.isBookmarked = isBookmarked
        }
    }

    public func inject(input: Input, onBookmarkTapped: @escaping () -> Void) {
        cellView.setImage(image: input.image, backgroundColor: input.type.backgroundColor)
        cellView.setMainText(text: input.mainText)
        cellView.setSubText(text: input.subText)
        cellView.setBookmark(isBookmarked: input.isBookmarked)
        self.onBookmarkTapped = onBookmarkTapped
        cellView.onBookmarkTapped = { [weak self] _ in
            self?.onBookmarkTapped?()
        }
    }
}

extension DictionaryItemType {
    public var backgroundColor: UIColor {
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
