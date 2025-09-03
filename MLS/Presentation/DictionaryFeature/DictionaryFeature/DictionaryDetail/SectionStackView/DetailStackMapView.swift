import BaseFeature
import DesignSystem
import UIKit

final class DetailStackMapView: UIStackView {
    // MARK: - Type
    private enum Constant {
        static let mapCornerRadius: CGFloat = 16
        static let imageSize: CGFloat = UIScreen.main.bounds.width - 32
        static let mapLayoutMargin: UIEdgeInsets = .init(top: 20, left: 0, bottom: 0, right: 0)
    }

    /// 상세설명 메뉴에서 보여줄 상세 설명 스택 뷰 3가지
    public let mapImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .whiteMLS
        view.layer.cornerRadius = Constant.mapCornerRadius
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    init(imageUrl: String) {
        super.init(frame: .zero)
        addViews()
        setUpConstraints()
        configureUI()
        setUpMapView(imageUrl: imageUrl)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DetailStackMapView {
    func addViews() {
        addArrangedSubview(mapImageView)
    }

    func setUpConstraints() {
        mapImageView.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
        }
    }
    
    func configureUI() {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 20, left: 0, bottom: 0, right: 0)
    }

    func setUpMapView(imageUrl: String) {
        ImageLoader.shared.loadImage(url: URL(string: imageUrl), defaultImage: DesignSystemAsset.image(named: "testImage")) { [weak self] image in
            self?.mapImageView.image = image
        }
    }
}
