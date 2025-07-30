import UIKit

import DesignSystem

public final class CollectionListCell: UICollectionViewCell {
    // MARK: - Properties

    // MARK: - Components
    public let cellView = CollectionList()

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
private extension CollectionListCell {
    func addViews() {
        contentView.addSubview(cellView)
    }

    func setupContstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

public extension CollectionListCell {
    struct Input {
        let title: String
        let count: Int
        let images: [UIImage?]

        public init(title: String, count: Int, images: [UIImage?]) {
            self.title = title
            self.count = count
            self.images = images
        }
    }

    func inject(input: Input) {
        cellView.setImages(images: input.images)
        cellView.setTitle(text: input.title)
        cellView.setSubtitle(text: String(input.count))
    }
}
