import UIKit

import BaseFeature
import DesignSystem

import SnapKit

public final class SelectImageCell: UICollectionViewCell {
    // MARK: - Type
    enum Constant {
        static let inset: CGFloat = 28
    }

    // MARK: - Properties
    private var type: MapleIllustration?

    override public var isSelected: Bool {
        didSet {
            updateImage()
        }
    }

    // MARK: - Components
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }()

    private lazy var checkMarkContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary100.withAlphaComponent(0.5)

        view.addSubview(checkMarkView)

        checkMarkView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }

        return view
    }()

    private lazy var checkMarkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "72412C", alpha: 0.5)
        view.clipsToBounds = true

        view.addSubview(checkIcon)

        checkIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constant.inset)
        }
        return view
    }()

    private let checkIcon: UIImageView = {
        let view = UIImageView(image: DesignSystemAsset.image(named: "checkMark")?.withRenderingMode(.alwaysTemplate))
        view.tintColor = .whiteMLS
        return view
    }()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
        setupContstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.width * 0.4
        checkMarkView.layer.cornerRadius = checkMarkView.bounds.width * 0.4
    }
}

// MARK: - SetUp
private extension SelectImageCell {
    func addViews() {
        addSubview(imageView)
        imageView.addSubview(checkMarkContainerView)
    }

    func setupContstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        checkMarkContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func updateImage() {
        guard let type = type else { return }
        ImageLoader.shared.loadImage(stringURL: type.url) { [weak self] image in
            self?.imageView.image = image
        }
        checkMarkContainerView.isHidden = !isSelected
    }
}

public extension SelectImageCell {
    struct Input {
        let type: MapleIllustration
    }

    func inject(input: Input) {
        type = input.type
        updateImage()
    }
}
