import BaseFeature
import DesignSystem
import UIKit

class MapDictionaryDetailView: UIView {
    // MARK: - Type
    enum Constant {
        static let mapCornerRadius: CGFloat = 16
        static let imageSize: CGFloat = UIScreen.main.bounds.width - 32
    }
    
    // 상세설명 메뉴에서 보여줄 상세 설명 스택 뷰
    public let mapImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .whiteMLS
        view.layer.cornerRadius = Constant.mapCornerRadius
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()

    public let monsterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    public let npcStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    init(imageUrl: String) {
        super.init(frame: .zero)
        addViews()
        setUpConstraints()
        setUpMapView(imageUrl: imageUrl)
        setUpMonsterView()
        setUpNpcView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
extension MapDictionaryDetailView {
    func addViews() {
        addSubview(mapImageView)
    }
    
    func setUpConstraints() {
        mapImageView.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
        }
    }
    
    func setUpMapView(imageUrl: String) {
        ImageLoader.shared.loadImage(url: URL(string: imageUrl), defaultImage: DesignSystemAsset.image(named: "testImage")) { [weak self] image in
            self?.mapImageView.image = image
        }
    }
    
    func setUpMonsterView() {
        let label = UILabel()
        label.text = "출현 몬스터 정보 표시"
        label.textAlignment = .center
    }
    
    func setUpNpcView() {
        let label = UILabel()
        label.text = "출현 NPC 정보 표시"
        label.textAlignment = .center
    }
}
