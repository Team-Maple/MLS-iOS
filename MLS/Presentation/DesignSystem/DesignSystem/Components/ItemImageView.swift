import UIKit

import SnapKit

public final class ItemImageView: UIView {
    private let imageView = UIImageView()

    init(image: UIImage?, cornerRadius: CGFloat, inset: CGFloat, backgroundColor: UIColor) {
        super.init(frame: .zero)
        addViews()
        setUpConstraints(inset: inset)
        configureUI(radius: cornerRadius)
        setImage(image: image, backgroundColor: backgroundColor)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension ItemImageView {
    func addViews() {
        addSubview(imageView)
    }

    func setUpConstraints(inset: CGFloat) {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }
    }

    func configureUI(radius: CGFloat) {
        layer.cornerRadius = radius
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clearMLS
    }
}

public extension ItemImageView {
    func setImage(image: UIImage?, backgroundColor: UIColor) {
        imageView.image = image
        self.backgroundColor = backgroundColor
    }

    func setMapImage(image: UIImage?, backgroundColor: UIColor) {
        setImage(image: image, backgroundColor: backgroundColor)
        imageView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
    }
}
