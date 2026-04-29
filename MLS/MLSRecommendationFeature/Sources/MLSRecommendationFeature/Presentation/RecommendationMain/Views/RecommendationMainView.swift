import UIKit

import MLSCore
import MLSDesignSystem

import SnapKit

internal final class RecommendationMainView: UIView {
    // MARK: - Type
    private enum Constant {
        static let cellHeight: CGFloat = 104
        static let cellSpacing: CGFloat = 8
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
    
    internal let informationButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.font = .korFont(style: .regular, size: 16)
        label.text = "추천"
        let image = UIImageView(image: DesignSystemAsset.image(named: "errorBlack").withTintColor(.primary700))
        
        button.addSubview(label)
        button.addSubview(image)
        
        image.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.verticalEdges.trailing.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalTo(image.snp.leading).offset(-3)
        }
        return button
    }()

    // MARK: - init
    init() {
        super.init(frame: .zero)

        addViews()
        setupConstraints()
        configureUI()
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
        grayBackgroundView.addSubview(collectionView)
    }

    func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(21)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        grayBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(30)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        informationButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(informationButton.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    func configureUI() {}
}

