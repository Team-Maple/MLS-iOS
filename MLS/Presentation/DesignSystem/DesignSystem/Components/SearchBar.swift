import UIKit

import SnapKit

public final class SearchBar: UIView {
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
private extension SearchBar {
    func addViews() { }

    func setupConstraints() { }

    func configureUI() { }
}
