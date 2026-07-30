import UIKit

import MLSCore
import MLSDesignSystem

import SnapKit

internal final class RecommendationMainView: UIView {
    // MARK: - Type
    private enum Constant {
        static let profileTopOffset: CGFloat = 21
        static let profileHorizontalInset: CGFloat = 40
        static let grayViewTopOffset: CGFloat = 30
        static let informationButtonTopInset: CGFloat = 14
        static let informationButtonTrailingInset: CGFloat = 16
        static let informationIconSize: CGFloat = 24
        static let informationLabelIconSpacing: CGFloat = 3
        static let collectionViewTopOffset: CGFloat = 14
        static let collectionViewHorizontalInset: CGFloat = 16
        static let cellHeight: CGFloat = 104
        static let cellSpacing: CGFloat = 8
        static let bottomTabHeight: CGFloat = 64
        static let emptyLabelTopOffset: CGFloat = 16
    }

    // MARK: - Properties
    internal let header = Header(style: .main, title: "추천")
    internal let profileView = RecommendationProfileView()

    internal let grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral100
        return view
    }()

    internal let collectionView: UICollectionView = {
        let layout = CompositionalLayoutBuilder()
            .section {
                $0.item(width: .fractionalWidth(1), height: .fractionalHeight(1))
                    .group(.vertical, width: .fractionalWidth(1), height: .absolute(Constant.cellHeight))
                    .buildSection()
                    .interGroupSpacing(Constant.cellSpacing)
            }
            .build()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        return view
    }()

    internal let informationButton = UIButton()
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .korFont(style: .regular, size: 16)
        label.text = "추천"
        return label
    }()

    private let informationIconView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "errorBlack").withTintColor(.primary700)
        return view
    }()

    private let emptyDataLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_s_r, text: "추천 정보가 존재하지 않습니다.", color: .neutral600, alignment: .center)
        label.isHidden = true
        return label
    }()

    internal let emptyView = ToLoginView(type: .recommend)

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
private extension RecommendationMainView {
    func addViews() {
        addSubview(header)
        addSubview(profileView)
        addSubview(grayBackgroundView)
        grayBackgroundView.addSubview(informationButton)
        informationButton.addSubview(informationLabel)
        informationButton.addSubview(informationIconView)
        grayBackgroundView.addSubview(collectionView)
        addSubview(emptyView)
        addSubview(emptyDataLabel)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }

        profileView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(Constant.profileTopOffset)
            make.horizontalEdges.equalToSuperview().inset(Constant.profileHorizontalInset)
        }

        grayBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(Constant.grayViewTopOffset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constant.bottomTabHeight)
        }

        informationButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.informationButtonTopInset)
            make.trailing.equalToSuperview().inset(Constant.informationButtonTrailingInset)
        }

        informationIconView.snp.makeConstraints { make in
            make.size.equalTo(Constant.informationIconSize)
            make.verticalEdges.trailing.equalToSuperview()
        }

        informationLabel.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.trailing.equalTo(informationIconView.snp.leading).offset(-Constant.informationLabelIconSpacing)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(informationButton.snp.bottom).offset(Constant.collectionViewTopOffset)
            make.horizontalEdges.equalToSuperview().inset(Constant.collectionViewHorizontalInset)
            make.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constant.bottomTabHeight)
        }
        emptyView.isHidden = true

        emptyDataLabel.snp.makeConstraints { make in
            make.top.equalTo(informationButton.snp.bottom).offset(Constant.emptyLabelTopOffset)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Login State
extension RecommendationMainView {
    func updateLoginState(isLogin: Bool) {
        profileView.isHidden = !isLogin
        grayBackgroundView.isHidden = !isLogin
        emptyView.isHidden = isLogin
        emptyDataLabel.isHidden = !isLogin
    }

    func checkEmptyData(isEmpty: Bool) {
        collectionView.isHidden = isEmpty
        emptyDataLabel.isHidden = !isEmpty
    }
}
