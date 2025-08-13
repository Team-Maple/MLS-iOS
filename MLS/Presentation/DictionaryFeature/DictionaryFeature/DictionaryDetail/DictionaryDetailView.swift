import UIKit

import DesignSystem
import DomainInterface

import SnapKit

final class DictionaryDetailView: UIView {
    // MARK: - Type
    enum Constant {
        static let iconInset: CGFloat = 10
        static let navHeight: CGFloat = 44
        static let buttonSize: CGFloat = 44
    }

    // MARK: - Components
    /// 해당 네비게이션은 컴포넌트로 분리가 안되어있어서 이를 구성하기 위한 뷰
    private let navigation = UIView()
    
    public let backButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "arrowBack")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets.init(top: Constant.iconInset, left: Constant.iconInset, bottom: Constant.iconInset, right: Constant.iconInset)), for: .normal)
        button.tintColor = .textColor
        return button
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_b, text: "몬스터 상세 정보")
        return label
    }()
    
    public let dictButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "dictionary")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets.init(top: Constant.iconInset, left: Constant.iconInset, bottom: Constant.iconInset, right: Constant.iconInset)), for: .normal)
        button.tintColor = .textColor
        return button
    }()
    
    public let reportButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "errorBlack")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets.init(top: Constant.iconInset, left: Constant.iconInset, bottom: Constant.iconInset, right: Constant.iconInset)), for: .normal)
        button.tintColor = .textColor
        return button
    }()
    
    /// 상세 화면 전체를 구성하는 collectionView
    public let detailCollectionView: UICollectionView = {
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
private extension DictionaryDetailView {
    func addViews() {
        addSubview(navigation)
        navigation.addSubview(backButton)
        navigation.addSubview(titleLabel)
        navigation.addSubview(dictButton)
        navigation.addSubview(reportButton)
        
        addSubview(detailCollectionView)
    }

    func setupConstraints() {
        navigation.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constant.navHeight)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(Constant.buttonSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        dictButton.snp.makeConstraints { make in
            make.trailing.equalTo(reportButton.snp.leading)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constant.buttonSize)
        }
        
        reportButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(Constant.buttonSize)
        }
        
        detailCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigation.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
        detailCollectionView.backgroundView = CustomBackgroundView()
    }
}

class CustomBackgroundView: UIView {
    /// 스크롤시 배경을 위(흰색), 아래(회색)을 분리하기 위한 배경 뷰를 그리는 함수
    override func draw(_ rect: CGRect) {
        UIColor.whiteMLS.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 0, width: rect.width, height: 200)).fill()
        
        UIColor.neutral200.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 200, width: rect.width, height: rect.height - 200)).fill()
    }
}
