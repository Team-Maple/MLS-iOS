import BaseFeature
import DesignSystem
import UIKit

final class DetailStackMapView: UIStackView {
    // MARK: - Type
    private enum Constant {
        static let mapCornerRadius: CGFloat = 16
        static let mapLayoutMargin: UIEdgeInsets = .init(top: 20, left: 16, bottom: 0, right: 16)
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
            make.height.equalTo(mapImageView.snp.width)
        }
    }

    func configureUI() {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = Constant.mapLayoutMargin
    }
}

extension DetailStackMapView {
    func setUpMapView(imageUrl: String?) {
        ImageLoader.shared.loadImage(stringURL: imageUrl) { [weak self] image in
            if image == DesignSystemAsset.image(named: "connectionError") {
                self?.mapImageView.snp.remakeConstraints { make in
                    make.size.equalTo(165)
                }
            } else {
                self?.mapImageView.snp.remakeConstraints { make in
                    make.height.equalTo(self?.mapImageView.snp.width ?? 0)
                }
            }
            self?.mapImageView.image = image
        }
    }
}
