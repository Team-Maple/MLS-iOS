import DesignSystem
import SnapKit
import UIKit

public final class RecentSearchHeaderView: UICollectionReusableView {
    // MARK: - Components
    private let titleLabel = UILabel()
    private let deleteButton = UIButton()
    private let spacer = UIView()

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension RecentSearchHeaderView {
    func addViews() {
        addSubview(titleLabel)
        addSubview(spacer)
        addSubview(deleteButton)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        spacer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalTo(deleteButton.snp.leading)
        }

        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    func configureUI() {
        titleLabel.attributedText = .makeStyledString(
            font: .sub_m_b,
            text: "최근 검색어",
            alignment: .left
        )

        deleteButton.setTitle("모두 지우기", for: .normal)
        deleteButton.titleLabel?.font = .b_s_r
        deleteButton.setTitleColor(.neutral600, for: .normal)
    }
}
