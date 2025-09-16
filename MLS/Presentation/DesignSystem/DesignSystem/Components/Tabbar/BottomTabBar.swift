import UIKit

import SnapKit

// MARK: - Model
public struct TabItem {
    var title: String
    var icon: UIImage
}

public final class BottomTabBar: UIStackView {
    // MARK: - Type
    private enum Constant {
        static let height: CGFloat = 64
        static let buttonSize: CGFloat = 64
    }

    // MARK: - Properties
    public var onTabSelected: ((Int) -> Void)?
    private var heightConstraint: Constraint?

    private var tabButtons: [TabButton] = []
    private var selectedIndex: Int = 0 {
        didSet {
            selectIndex()
        }
    }

    // MARK: - Init
    public init(tabItems: [TabItem], selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        super.init(frame: .zero)
        setUpConstraints()
        configureUI(tabItems: tabItems)
        setupStackView()
        selectIndex()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        guard let window = window else { return }
        let bottomInset = window.safeAreaInsets.bottom
        heightConstraint?.update(offset: Constant.height + bottomInset)
    }

    // MARK: - Setup

    private func setUpConstraints() {
        snp.makeConstraints { make in
            heightConstraint = make.height.equalTo(Constant.height).constraint
        }
    }

    private func configureUI(tabItems: [TabItem]) {
        tabButtons.forEach { $0.removeFromSuperview() }
        tabButtons.removeAll()
        arrangedSubviews.forEach { removeArrangedSubview($0); $0.removeFromSuperview() }

        for (index, item) in tabItems.enumerated() {
            if index > 0 {
                let spacer = UIView()
                spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
                spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                addArrangedSubview(spacer)
            }

            let button = TabButton(icon: item.icon, text: item.title)
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            addArrangedSubview(button)
            tabButtons.append(button)

            button.snp.makeConstraints { make in
                make.size.equalTo(Constant.buttonSize)
            }
        }
    }

    private func setupStackView() {
        backgroundColor = .systemBackground
        axis = .horizontal
        distribution = .equalSpacing
        spacing = 0
        isLayoutMarginsRelativeArrangement = true

    }

    @objc private func tabButtonTapped(_ sender: TabButton) {
        let newIndex = sender.tag
        guard newIndex != selectedIndex else { return }
        selectedIndex = newIndex
        onTabSelected?(newIndex)
    }

    private func selectIndex() {
        for (index, button) in tabButtons.enumerated() {
            button.isSelected = (index == selectedIndex)
        }
    }

    public func selectTab(index: Int) {
        guard index != selectedIndex else { return }
        selectedIndex = index
    }
}
