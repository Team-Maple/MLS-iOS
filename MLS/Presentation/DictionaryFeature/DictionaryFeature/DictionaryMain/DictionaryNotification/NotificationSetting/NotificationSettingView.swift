import UIKit

import DesignSystem

import SnapKit

public final class NotificationSettingView: UIView {
    // MARK: - Type
    enum Constant {
        static let topMargin: CGFloat = 20
        static let spacing: CGFloat = 16
        static let horizontalMargin: CGFloat = 16
    }

    // MARK: - Components
    public let header = NavigationBar(type: .withString("설정"))

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .subTitleBold, text: "실시간 알림", alignment: .left)
        return label
    }()

    public let subTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .body, text: "신규 이벤트가 있으때 실시간으로 알림을 보내드려요.", color: .neutral700, alignment: .left)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let toggleBox = ToggleBox(text: "알림 설정")

    public let notificationCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - SetUp
private extension NotificationSettingView {
    func addViews() {
        addSubview(header)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(toggleBox)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(Constant.topMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.spacing)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
        }

        toggleBox.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(Constant.topMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
        }
    }

    func configureUI() {
        backgroundColor = .clearMLS
        header.rightButton.isHidden = true
    }
}
