import UIKit

import DesignSystem

import SnapKit

public final class PopularSearchHeaderView: UICollectionReusableView {
    // MARK: - Type
    private enum Constant {
        static let spacing: CGFloat = 4
        static let topInset: CGFloat = 24
    }

    // MARK: - Components
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MAKR: - SetUp
private extension PopularSearchHeaderView {
    func addViews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.topInset)
            make.leading.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).priority(.low)
            make.trailing.equalToSuperview().priority(.high)
            make.centerY.equalTo(titleLabel)
        }
    }

    func configureUI() {
        titleLabel.font = .sub_l_b
        titleLabel.textAlignment = .left

        subtitleLabel.font = .cp_s_r
        subtitleLabel.textColor = .neutral500
        subtitleLabel.textAlignment = .left
    }
}

// MARK: - Methods
public extension PopularSearchHeaderView {
    func inject(mainText: String, subText: String, hasRecent: Bool) {
        titleLabel.text = mainText
        subtitleLabel.text = subText
        if hasRecent {
            titleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(Constant.topInset)
                make.horizontalEdges.equalToSuperview()
            }
        } else {
            titleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
            }
        }
    }
}
