import DesignSystem
import UIKit

final public class DescriptionBackgroundView: UICollectionReusableView {
    // MARK: - Type
    enum Constant {
        static let horizontalInset: CGFloat = 16
        static let topInset: CGFloat = 60
        static let bottomInset: CGFloat = 20
    }

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteMLS
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
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

private extension DescriptionBackgroundView {
    private func addViews() {
        addSubview(containerView)
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.topInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.bottomInset)
        }
    }
}
