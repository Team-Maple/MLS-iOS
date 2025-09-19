import UIKit

import DesignSystem

import SnapKit

final class SelectImageView: UIView {
    private enum Constant {
        static let imageSize: CGFloat = 104
        static let topMargin: CGFloat = 16
        static let headerHeight: CGFloat = 32
        static let bottomMargin: CGFloat = 24
        static let buttonBottomMargin: CGFloat = 4
        static let horizontalInset: CGFloat = 16
    }

    // MARK: - Components
    public let header = Header(style: .filter, title: "프로필 이미지를 선택해주세요.")

    public let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    public let applyButton = CommonButton(style: .normal, title: "적용", disabledTitle: nil)

    // MARK: - init
    init() {
        super.init(frame: .zero)

        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension SelectImageView {
    func addViews() {
        addSubview(header)
        addSubview(imageCollectionView)
        addSubview(applyButton)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.topMargin)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constant.headerHeight)
        }

        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }

        applyButton.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(Constant.bottomMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.buttonBottomMargin)
        }
    }
}
