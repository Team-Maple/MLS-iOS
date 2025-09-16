import DesignSystem
import UIKit

final public class SettingBackgroundView: UICollectionReusableView {
    // MARK: - Type
    enum Constant {
        static let radius: CGFloat = 16
        static let topInset: CGFloat = 20
        static let horizontalInset: CGFloat = 16
    }

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteMLS
        view.layer.cornerRadius = Constant.radius
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .neutral100
        addViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension SettingBackgroundView {
    private func addViews() {
        addSubview(containerView)
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.topInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview()
        }
    }
}
