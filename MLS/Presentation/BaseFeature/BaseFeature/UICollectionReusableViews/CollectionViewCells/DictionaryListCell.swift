import UIKit

import DesignSystem
import DomainInterface

public final class DictionaryListCell: UICollectionViewCell {
    // MARK: - Properties
    private var onBookmarkTapped: ((Bool) -> Void)?

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

    public override func prepareForReuse() {
        super.prepareForReuse()

        onBookmarkTapped = nil
        cellView.onIconTapped = nil

        cellView.setImage(image: UIImage(), backgroundColor: .clear)
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

    func inject(type: CardList.CardListType, input: Input, onBookmarkTapped: @escaping (Bool) -> Void) {
        cellView.setType(type: type)
        // URL이 유효할 때만 요청
        if let url = URL(string: input.imageUrl) {
            ImageLoader.shared.loadImage(url: url) { image in
                guard let image = image else { return }
                self.cellView.setImage(image: image, backgroundColor: input.type.backgroundColor)
            }
        }
        cellView.setMainText(text: input.mainText)
        cellView.setSubText(text: input.subText)
        cellView.setSelected(isSelected: input.isBookmarked)
        self.onBookmarkTapped = onBookmarkTapped
        cellView.onIconTapped = { [weak self] isSelected in
            self?.onBookmarkTapped?(isSelected)
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
