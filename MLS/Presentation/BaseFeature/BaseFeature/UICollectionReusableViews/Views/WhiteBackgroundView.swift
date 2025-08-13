import UIKit
import DesignSystem

final public class WhiteBackgroundView: UICollectionReusableView {
    // MARK: - Type
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteMLS
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

private extension WhiteBackgroundView {
    private func addViews() {
        addSubview(containerView)
    }
    
    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
