import UIKit

import SnapKit

public final class DividerView: UIView {
    // MARK: - init
    public init() {
        super.init(frame: .zero)
        self.backgroundColor = .neutral200
        self.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}
