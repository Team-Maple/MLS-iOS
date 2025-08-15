import UIKit

import DesignSystem
import DomainInterface
/// 출현맵, 드롭아이템에 공통으로 사용할 수 잇는 셀
final class DictionaryDetailListCell: UICollectionViewCell {
    struct Constant {
        static let horizontalInset: CGFloat = 16
    }

    public let cellView = CardList()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - Setup
private extension DictionaryDetailListCell {
    func addViews() {
        contentView.addSubview(cellView)
    }

    func setupConstraints() {
        cellView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
    }
}

extension DictionaryDetailListCell {
    struct Input {
        let type: DictionaryItemType
        let image: UIImage
        let mainText: String
        let subText: String

    }
    // titleLabel이 추가 정보의 제목, valueLabel이 추가 정보의 값 -> ex)드롭률, 0.005%
    func inject(type: CardList.CardListType, input: Input, titleLabel: String? = "", valueLabel: String? = "") {
        cellView.setType(type: type)
        cellView.setImage(image: input.image, backgroundColor: input.type.backgroundColor)
        cellView.setMainText(text: input.mainText)
        cellView.setSubText(text: input.subText)
        cellView.setDropInfoText(title: titleLabel ?? "", value: valueLabel ?? "")
    }
}
