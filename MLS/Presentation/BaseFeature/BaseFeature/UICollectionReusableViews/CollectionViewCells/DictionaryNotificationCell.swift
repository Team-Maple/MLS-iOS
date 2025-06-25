import UIKit

import DesignSystem

import RxSwift
import SnapKit

public class DictionaryNotificationCell: UICollectionViewCell {
    // MARK: - Type
    struct Constant {
        static let horizontalInset: CGFloat = 20
        static let verticalInset: CGFloat = 16
        static let spacing: CGFloat = 4
    }

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let underLine = DividerView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        configureUI()
    }

    public var disposeBag = DisposeBag()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictionaryNotificationCell {
    func addViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(underLine)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.verticalInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.spacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.verticalInset)
        }
        
        underLine.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }

    func configureUI() {
        underLine.backgroundColor = .neutral500
    }
}

public extension DictionaryNotificationCell {
    struct Input {
        let title: String
        let subTitle: String
        let isChecked: Bool
        
        public init(title: String, subTitle: String, isChecked: Bool) {
            self.title = title
            self.subTitle = subTitle
            self.isChecked = isChecked
        }
    }
    
    func inject(input: Input) {
        titleLabel.attributedText = .makeStyledString(font: .subTitle, text: input.title, color: input.isChecked ? .neutral500 : .textColor, alignment: .left)
        subTitleLabel.attributedText = .makeStyledString(font: .caption, text: input.subTitle, color: input.isChecked ? .neutral500 : .neutral700, alignment: .left)
        backgroundColor = input.isChecked ? .clearMLS : .neutral100
    }
}
