import UIKit

import BaseFeature
import DesignSystem

final class PinchMapView: UIView {
    // MARK: - Type
    private enum Constant {
        static let iconInset: CGFloat = 10
        static let navHeight: CGFloat = 44
        static let buttonSize: CGFloat = 44
    }

    // MARK: - Components
    public let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.backgroundColor = .clearMLS
        return scrollView
    }()

    public let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clearMLS
        view.layer.opacity = 0.9
        return view
    }()

    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "largeX")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .whiteMLS
        return button
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
private extension PinchMapView {
    func addViews() {
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        addSubview(backButton)
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(54)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
    }

    func configureUI() {
        backgroundColor = .textColor.withAlphaComponent(0.9)
    }
}

// MARK: - Methods
extension PinchMapView {
    func setImage(imageUrl: String) {
        ImageLoader.shared.loadImage(stringURL: imageUrl) { [weak self] image in
            self?.imageView.image = image
        }
    }
}
