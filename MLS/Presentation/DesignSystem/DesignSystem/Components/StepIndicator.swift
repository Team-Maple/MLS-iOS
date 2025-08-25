import UIKit

import SnapKit

public final class StepIndicator: UIStackView {
    // MARK: - Type
    private enum Constant {
        static let circleSize: CGFloat = 8
        static let spacing: CGFloat = 8
    }

    // MARK: - Components

    // MARK: - init
    public init(circleCount: Int) {
        super.init(frame: .zero)
        configureUI(circleCount: circleCount)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension StepIndicator {
    func configureUI(circleCount: Int) {
        axis = .horizontal
        distribution = .fillEqually
        spacing = Constant.spacing

        for _ in 0 ..< circleCount {
            let view = UIImageView(image: DesignSystemAsset.image(named: "circle")?.withRenderingMode(.alwaysTemplate))
            view.contentMode = .scaleAspectFit
            view.tintColor = .neutral300
            addArrangedSubview(view)
        }

        arrangedSubviews.forEach { view in
            view.snp.makeConstraints { make in
                make.size.equalTo(Constant.circleSize)
            }
        }
    }
}

public extension StepIndicator {
    func selectIndicator(index: Int) {
        guard index >= 0, index < arrangedSubviews.count else { return }

        arrangedSubviews.enumerated().forEach { circleIndex, view in
            guard let circle = view as? UIImageView else { return }
            circle.tintColor = (index == circleIndex) ? .primary700 : .neutral300
        }
    }
}
