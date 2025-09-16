import UIKit

import DesignSystem

import SnapKit

public final class MyPageMainView: UIView {
    // MARK: - Type
    enum Constant {
        static let titleLabelHeight: CGFloat = 44
        static let colletionViewTopMargin: CGFloat = 20
        static let horizontalInset: CGFloat = 16
    }

    // MARK: - Properties

    // MARK: - Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xxxl_b, text: "마이페이지", alignment: .left)
        return label
    }()

    public let mainCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .neutral100
        return collectionView
    }()

    // MARK: - init
    public init() {
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
private extension MyPageMainView {
    func addViews() {
        addSubview(titleLabel)
        addSubview(mainCollectionView)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.layoutMarginsGuide)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.height.equalTo(Constant.titleLabelHeight)
        }

        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.colletionViewTopMargin)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
    }
}
