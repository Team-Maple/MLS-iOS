import UIKit

import DesignSystem

import SnapKit

public final class DictionaryNotificationView: UIView {
    // MARK: - Type
    enum Constant {
        static let emptyViewTopMargin: CGFloat = 120

        static let titleTopMargin: CGFloat = 20
        static let titleBottomMargin: CGFloat = 18
        static let titleHorizontalInset: CGFloat = 16
        static let titleHeight: CGFloat = 34
        static let titleWidth: CGFloat = 42
    }

    // MARK: - Components
    private let emptyView = NotificationEmptyView()
    public let header = NavigationBar(type: .withString("설정"))
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .heading3SemiBold, text: "알림", alignment: .left)
        return label
    }()

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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictionaryNotificationView {
    func addViews() {
        addSubview(emptyView)

        addSubview(header)
        addSubview(titleLabel)
        addSubview(notificationCollectionView)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        emptyView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(Constant.emptyViewTopMargin)
            make.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(Constant.titleTopMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.titleHorizontalInset)
        }

        notificationCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.titleBottomMargin)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .clearMLS
        header.rightButton.isHidden = true
    }
}

public extension DictionaryNotificationView {
    func setEmpty(isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        titleLabel.isHidden = isEmpty
        notificationCollectionView.isHidden = isEmpty
    }
}
