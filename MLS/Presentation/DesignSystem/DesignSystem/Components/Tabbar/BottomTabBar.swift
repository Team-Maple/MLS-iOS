import UIKit

internal import SnapKit

// MARK: - Model
public struct TabItem {
    var title: String
    var icon: UIImage
}

public final class BottomTabBar: UIStackView {
    // MARK: - Properties
    public var onTabSelected: ((Int) -> Void)?

    private var tabButtons: [TabButton] = []
    private var selectedIndex: Int = 0 {
        didSet {
            selectIndex()
        }
    }

    // MARK: - Components
    private let divider = DividerView()

    // MARK: - Init
    public init(tabItems: [TabItem], selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        super.init(frame: .zero)
        addViews()
        setUpConstraints()
        configureUI(tabItems: tabItems)
        setupStackView()
        selectIndex()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func addViews() {
        addSubview(divider)
    }

    private func setUpConstraints() {
        divider.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }

    private func configureUI(tabItems: [TabItem]) {
        tabButtons.forEach { $0.removeFromSuperview() }
        tabButtons.removeAll()

        for (index, item) in tabItems.enumerated() {
            let button = TabButton(icon: item.icon, text: item.title)
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            addArrangedSubview(button)
            tabButtons.append(button)
        }

        selectIndex()
    }

    private func setupStackView() {
        backgroundColor = .systemBackground
        spacing = 0
        distribution = .fillEqually
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
}
