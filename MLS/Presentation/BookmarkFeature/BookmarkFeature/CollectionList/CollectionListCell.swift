import BaseFeature
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
        let images: [String?]

        public init(title: String, count: Int, images: [String?]) {
            self.title = title
            self.count = count
            self.images = images
        }
    }

    func inject(input: Input) {
        loadImages(from: input.images) { [weak self] images in
            print("이미지:\(images)")
            self?.cellView.setImages(images: images)
        }
        cellView.setTitle(text: input.title)
        cellView.setSubtitle(text: "\(String(input.count))개")
    }
}

private func loadImages(from urls: [String?], completion: @escaping ([UIImage?]) -> Void) {

    var results = [UIImage?](repeating: nil, count: urls.count)
    let dispatchGroup = DispatchGroup()

    for (index, urlString) in urls.enumerated() {
        dispatchGroup.enter()

        ImageLoader.shared.loadImage(stringURL: urlString) { image in
            results[index] = image
            dispatchGroup.leave()
        }
    }

    dispatchGroup.notify(queue: .main) {
        completion(results)
    }
}
