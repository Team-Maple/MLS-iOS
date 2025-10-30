// import UIKit
//
// import BaseFeature
// import DesignSystem
// import DomainInterface
//
// final class DictionaryListCell: UICollectionViewCell {
//    // MARK: - Properties
//    private var onBookmarkTapped: ((Bool) -> Void)?
//
//    // MARK: - Components
//    public let cellView = CardList()
//    private var imageDownloadTask: URLSessionDataTask?
//
//    // MARK: - init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addViews()
//        setupContstraints()
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("\(#file), \(#function) Error")
//    }
// }
//
//// MARK: - SetUp
// private extension DictionaryListCell {
//    func addViews() {
//        contentView.addSubview(cellView)
//    }
//
//    func setupContstraints() {
//        cellView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
// }
//
// extension DictionaryListCell {
//    struct Input {
//        let type: DictionaryItemType
//        let mainText: String
//        let subText: String
//        let imageUrl: String
//        let isBookmarked: Bool
//    }
//
//    func inject(type: CardList.CardListType, input: Input, onBookmarkTapped: @escaping (Bool) -> Void) {
//        cellView.setType(type: type)
//        // URL이 유효할 때만 요청
//        if let url = URL(string: input.imageUrl) {
//            ImageLoader.shared.loadImage(url: url) { image in
//                guard let image = image else { return }
//                self.cellView.setImage(image: image, backgroundColor: input.type.backgroundColor)
//            }
//        }
//        cellView.setMainText(text: input.mainText)
//        cellView.setSubText(text: input.subText)
//        cellView.setSelected(isSelected: input.isBookmarked)
//        self.onBookmarkTapped = onBookmarkTapped
//        cellView.onIconTapped = { [weak self] isSelected in
//            self?.onBookmarkTapped?(isSelected)
//        }
//    }
// }
//
// public extension DictionaryItemType {
//    var backgroundColor: UIColor {
//        switch self {
//        case .item:
//            .listItem
//        case .monster:
//            .listMonster
//        case .map:
//            .listMap
//        case .npc:
//            .listNPC
//        case .quest:
//            .listQuest
//        }
//    }
// }
