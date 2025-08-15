import DesignSystem
import UIKit

final public class Neutral100BackgroundView: UICollectionReusableView {
    // MARK: - Type
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral100
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .neutral200
        addViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension Neutral100BackgroundView {
    private func addViews() {
        addSubview(containerView)
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
