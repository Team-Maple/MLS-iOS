import MLSCore
import MLSDesignSystem
import SnapKit
import UIKit

final class CollectionListCell: UICollectionViewCell {
    let cellView = CollectionList()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

extension CollectionListCell {
    struct Input {
        let title: String
        let count: Int
        let images: [String?]
    }

    func inject(input: Input) {
        loadImages(from: input.images) { [weak self] images in
            self?.cellView.setImages(images: images)
        }
        cellView.setTitle(text: input.title)
        cellView.setSubtitle(text: "\(input.count)개")
    }
}

@MainActor
private func loadImages(from urls: [String?], completion: @escaping ([UIImage?]) -> Void) {
    var results = [UIImage?](repeating: nil, count: urls.count)
    let group = DispatchGroup()
    for (index, urlString) in urls.enumerated() {
        group.enter()
        ImageLoader.shared.loadImage(stringURL: urlString) { image in
            results[index] = image
            group.leave()
        }
    }
    group.notify(queue: .main) {
        completion(results)
    }
}
