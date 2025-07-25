import UIKit

import DesignSystem
import DomainInterface

public final class DictionaryListCell: UICollectionViewCell {
    // MARK: - Properties
//    private var onIconTapped: (() -> Void)?

    // MARK: - Components
    public var cellView = CardList()

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
        let isSelected: Bool
        
        public init(type: DictionaryItemType, mainText: String, subText: String, image: UIImage, isSelected: Bool) {
            self.type = type
            self.mainText = mainText
            self.subText = subText
            self.image = image
            self.isSelected = isSelected
        }
    }

    public func inject(type: CardList.CardListType, input: Input, onIconTapped: @escaping () -> Void) {
        cellView.setType(type: type)
        cellView.setImage(image: input.image, backgroundColor: input.type.backgroundColor)
        cellView.setMainText(text: input.mainText)
        cellView.setSubText(text: input.subText)
        cellView.setSelected(isSelected: input.isSelected)
//        self.onIconTapped = onIconTapped
        cellView.onIconTapped = { _ in
            onIconTapped()
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
