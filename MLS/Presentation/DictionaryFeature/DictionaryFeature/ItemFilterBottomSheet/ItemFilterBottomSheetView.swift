import UIKit

import SnapKit

final class ItemFilterBottomSheetView: UIView {
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
private extension ItemFilterBottomSheetView {
    func addViews() { }

    func setupConstraints() { }

    func configureUI() { }
}
