import UIKit

import DesignSystem

import SnapKit

public final class MyPageListCell: UICollectionViewCell {
    // MARK: - Type
    enum Constant {
        static let inset: CGFloat = 10
        static let iconSize: CGFloat = 24
        static let height: CGFloat = 50
    }
    
    // MARK: - Components
    private let titleLabel = UILabel()
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "arrowForward")
        return view
    }()

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
private extension MyPageListCell {
    func addViews() {
        addSubview(titleLabel)
        addSubview(iconView)
    }

    func setupContstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constant.inset)
            make.centerY.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing)/*.priority(.high)*/
            make.trailing.equalToSuperview().inset(Constant.inset)/*.priority(.high)*/
            make.centerY.equalToSuperview()
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }
    }
}

extension MyPageListCell {
    public struct Input {
        let title: String
        var isHeader: Bool = false
    }

    public func inject(input: Input) {
        titleLabel.attributedText = .makeStyledString(font: input.isHeader ? .sub_m_b : .b_m_r, text: input.title, alignment: .left)
        iconView.isHidden = input.isHeader
    }
}
