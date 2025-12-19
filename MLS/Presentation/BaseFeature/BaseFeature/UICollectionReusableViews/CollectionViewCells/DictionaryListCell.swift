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

    override public func prepareForReuse() {
        super.prepareForReuse()

        onBookmarkTapped = nil
        cellView.onIconTapped = nil
        cellView.setMainText(text: "")
        cellView.setSubText(text: nil)
        cellView.setSelected(isSelected: false)
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

public extension DictionaryListCell {
    struct Input {
        public let type: DictionaryItemType
        public let mainText: String
        public let subText: String?
        public let imageUrl: String
        public let isBookmarked: Bool

        public init(type: DictionaryItemType, mainText: String, subText: String?, imageUrl: String, isBookmarked: Bool) {
            self.type = type
            self.mainText = mainText
            self.subText = subText
            self.imageUrl = imageUrl
            self.isBookmarked = isBookmarked
        }
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
        cellView.setImage(image: UIImage(), backgroundColor: input.type.backgroundColor) // 초기화

        if let url = URL(string: input.imageUrl) {
            ImageLoader.shared.loadImage(url: url) { [weak self] image in
                guard let self = self else { return }
                // 셀이 재사용된 경우, indexPath가 다르면 무시
                if let currentIndex = collectionView.indexPath(for: self),
                   currentIndex == indexPath {
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
