import UIKit

import DesignSystem

import SnapKit

public final class SelectImageCell: UICollectionViewCell {
    // MARK: - Type
    enum Constant {
        static let inset: CGFloat = 10
        static let iconSize: CGFloat = 24
        static let height: CGFloat = 50
    }

    // MARK: - Components
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
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
}

// MARK: - SetUp
private extension SelectImageCell {
    func addViews() {
        addSubview(imageView)
    }

    func setupContstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SelectImageCell {
    public struct Input {
        let type: MapleIllustration
    }

    public func inject(input: Input) {
        imageView.image = DesignSystemAsset.loadMapleIllustration(type: input.type)
    }
}
