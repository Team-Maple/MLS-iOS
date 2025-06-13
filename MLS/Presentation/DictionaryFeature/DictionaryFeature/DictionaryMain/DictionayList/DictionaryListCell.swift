import UIKit

import DesignSystem

final class DictionaryListCell: UICollectionViewCell {
    // MARK: - Properties
    private var onBookmarkTapped: (() -> Void)?

    // MARK: - Components
    private let cellView = CardList()

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

    func inject(input: Input, onBookmarkTapped: @escaping () -> Void) {
        cellView.loadImage(image: input.image)
        cellView.setMainText(text: input.mainText)
        cellView.setSubText(text: input.subText)
        cellView.setBookMark(isBookmarked: input.isBookmarked)
        cellView.setBackgroundColor(color: input.type.backgroundColor)
        self.onBookmarkTapped = onBookmarkTapped
        cellView.onBookmarkTapped = { [weak self] in
            self?.onBookmarkTapped?()
        }
    }
}
