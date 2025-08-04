import UIKit

import SnapKit

public final class FloatingActionButton: UIButton {
    // MARK: - Properties
    private var action: (() -> Void)?

    // MARK: - LifeCycle
    public init(action: @escaping () -> Void) {
        self.action = action
        super.init(frame: .zero)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension FloatingActionButton {
    func configureUI() {
        setImage(.fab, for: .normal)
        layer.cornerRadius = 24
        clipsToBounds = true
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        action?()
    }
}
