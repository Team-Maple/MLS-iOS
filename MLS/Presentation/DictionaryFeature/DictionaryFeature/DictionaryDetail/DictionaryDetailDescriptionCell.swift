import UIKit

import DesignSystem
import DomainInterface

/// 도감상세 - 상세정보에 사용되는 셀
final class DictionaryDetailDescriptionCell: UICollectionViewCell {
    // MARK: - Type
    struct Constant {
        // 헤더의 좌우 마진을 조정하기위해서 16 + 10으로 설정
        static let horizontalInset: CGFloat = 26
    }
    
    // MARK: - Components
    public var cellView = DictionaryDetailListView()

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
private extension DictionaryDetailDescriptionCell {
    func addViews() {
        contentView.addSubview(cellView)
    }

    func setupContstraints() {
        cellView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.verticalEdges.equalToSuperview()
        }
    }
}

extension DictionaryDetailDescriptionCell {
    /// main or clickableMain / additional / sub or clickableSub
    /// 이렇게 3가지로 구성
    struct Input {
        let mainText: String?
        let clickableMainText: String?
        let additionalText: String?
        let subText: String?
        let clickableSubText: String?
    }

    func inject(input: Input) {
        cellView.update(mainText: input.mainText, clickableMainText: input.clickableMainText, additionalText: input.additionalText, subText: input.subText, clickableSubText: input.clickableSubText)
    }
}
