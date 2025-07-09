import UIKit

import DesignSystem

import SnapKit

final class BookmarkMainView: UIView {
    // MARK: - Type
    enum Constant {
        static let buttonTopMargin: CGFloat = 12
        static let buttonBottomMargin: CGFloat = 14
        static let horizontalMargin: CGFloat = 16
        static let backButtonSize: CGFloat = 24
        static let titleTopMargin: CGFloat = 20
        static let titleBottomMargin: CGFloat = 12
    }

    // MARK: - Components

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - SetUp
private extension BookmarkMainView {
    func addViews() {
   
    }

    func setupConstraints() {
     
    }
}

// MARK: - Methods
extension BookmarkModalView {
  
}
