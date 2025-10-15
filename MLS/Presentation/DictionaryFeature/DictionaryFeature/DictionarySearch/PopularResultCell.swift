import UIKit

import DesignSystem
import DomainInterface

final class PopularResultCell: UICollectionViewCell {
    // MARK: - Type
    private enum Constant {
        static let verticalInset: CGFloat = 8
        static let spacing: CGFloat = 8
        static let indexLabelWidth: CGFloat = 18
    }

    // MARK: - Components
    public let indexLabel = UILabel()
    public let textLabel = UILabel()

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
private extension PopularResultCell {
    func addViews() {
        contentView.addSubview(indexLabel)
        contentView.addSubview(textLabel)
    }

    func setupContstraints() {
        indexLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constant.verticalInset)
            make.leading.equalToSuperview()
            make.width.equalTo(Constant.indexLabelWidth)
        }

        textLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constant.verticalInset)
            make.leading.equalTo(indexLabel.snp.trailing).offset(Constant.spacing).priority(.high)
            make.trailing.equalToSuperview().priority(.low)
        }
    }
}

extension PopularResultCell {
    struct Input {
        let text: String
        let rank: Int
    }

    func inject(input: Input) {
        indexLabel.attributedText = .makeStyledString(font: input.rank < 4 ? .cp_s_m : .cp_s_r, text: "\(input.rank)", color: input.rank < 4 ? .primary700 : .neutral700, alignment: .center)
        textLabel.attributedText = .makeStyledString(font: input.rank < 4 ? .cp_s_m : .cp_s_r, text: input.text, color: input.rank < 4 ? .primary700 : .neutral700, alignment: .left)
    }
}
