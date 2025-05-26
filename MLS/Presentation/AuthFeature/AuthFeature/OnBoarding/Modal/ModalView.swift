import UIKit

internal import SnapKit

public final class ModalView: UIView {
    // MARK: - Properties

    // MARK: - init
    init() {
        super.init(frame: .zero)
        
        addViews()
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension ModalView {
    func addViews() { }

    func setupConstraints() { }

    func configureUI() { }
}
