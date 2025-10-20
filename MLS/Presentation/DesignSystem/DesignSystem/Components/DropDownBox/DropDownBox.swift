import UIKit

import SnapKit

public final class DropDownBox: UIStackView {
    // MARK: - Properties
    private var isExpanded = false
    private var tableViewHeightConstraint: Constraint?
    private var selectedIndex: Int? {
        didSet {
            tableView.reloadData()
        }
    }

    public var selectedItem: Item? {
        guard let index = selectedIndex, items.indices.contains(index) else {
            return nil
        }
        return items[index]
    }

    // 선택 이벤트 콜백
    public var onItemSelected: ((Item) -> Void)?

    public var items = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Components
    public let inputBox = InputBox()

    private let iconButton: UIButton = {
        let view = UIButton()
        view.setImage(.arrowDropdown, for: .normal)
        return view
    }()

    public let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 8
        tableView.layer.borderColor = UIColor.neutral300.cgColor
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        tableView.register(DropDownBoxCell.self, forCellReuseIdentifier: "DropDownCell")
        return tableView
    }()

    // MARK: - Init
    public init(label: String? = nil, placeHodler: String? = nil, items: [Item]) {
        self.items = items
        super.init(frame: .zero)

        inputBox.label.attributedText = .makeStyledString(font: .b_s_r, text: label, color: .neutral700, alignment: .left)
        inputBox.textField.attributedPlaceholder = .makeStyledString(font: .b_m_r, text: placeHodler, color: .neutral500, alignment: .left)

        setupStackView()
        setupInputBox()
        setupTableView()
        configureTap()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension DropDownBox {
    func setupStackView() {
        axis = .vertical
        spacing = 4
        alignment = .fill
        addArrangedSubview(inputBox)
        addArrangedSubview(tableView)
    }

    func setupInputBox() {
        inputBox.borderView.addSubview(iconButton)

        inputBox.textField.snp.remakeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(20)
        }

        iconButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(inputBox.textField.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }

        inputBox.borderView.layer.borderColor = UIColor.neutral300.cgColor
        inputBox.textField.isUserInteractionEnabled = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        inputBox.borderView.addGestureRecognizer(tapGesture)
        inputBox.borderView.isUserInteractionEnabled = true
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(inputBox)
            tableViewHeightConstraint = make.height.equalTo(0).constraint
        }
    }

    func configureTap() {
        let action = UIAction { [weak self] _ in
            self?.toggleDropdown()
        }
        iconButton.addAction(action, for: .touchUpInside)
    }

    func toggleDropdown() {
        isExpanded.toggle()
        tableView.isHidden = !isExpanded
        iconButton.setImage(isExpanded ? .arrowDropUp : .arrowDropdown, for: .normal)
        let height = CGFloat(items.count) * 44 + tableView.contentInset.top + tableView.contentInset.bottom
        tableViewHeightConstraint?.update(offset: isExpanded ? height : 0)
    }

    func removeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    @objc private func handleTap() {
        toggleDropdown()
        removeKeyboard()
    }
}

// MARK: - UITableView
extension DropDownBox: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as? DropDownBoxCell else {
            return UITableViewCell()
        }
        let isSelected = selectedIndex == indexPath.row
        cell.injection(with: items[indexPath.row].name, isSelected: isSelected)
        cell.selectionStyle = .none
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let selectedItem = items[indexPath.row]
        inputBox.textField.attributedText = .makeStyledString(font: .b_m_r, text: selectedItem.name, alignment: .left, lineHeight: 1.0)
        inputBox.textField.sendActions(for: .editingChanged)
        toggleDropdown()

        onItemSelected?(selectedItem)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: Model
extension DropDownBox {
    public struct Item {
        public let name: String
        public let id: Int

        public init(name: String, id: Int) {
            self.name = name
            self.id = id
        }
    }

}
