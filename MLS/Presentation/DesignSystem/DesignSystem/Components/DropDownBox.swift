import UIKit

internal import SnapKit

public final class DropDownBox: UIStackView {
    // MARK: - Properties
    private var isExpanded = false
    private var tableViewHeightConstraint: Constraint?
    private var selectedIndex: Int? {
        didSet {
            tableView.reloadData()
        }
    }

    public var menus = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Components
    public let inputBox = InputBox()

    private let iconButton: UIButton = {
        let view = UIButton()
        view.setImage(.arrowDown, for: .normal)
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
    public init(label: String? = nil, placeHodler: String? = nil, menus: [String]) {
        self.menus = menus
        super.init(frame: .zero)

        inputBox.label.attributedText = .makeStyledString(font: .caption, text: label, color: .neutral700, alignment: .left)
        inputBox.textField.attributedPlaceholder = .makeStyledString(font: .body, text: placeHodler, color: .neutral500, alignment: .left)

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
            make.top.bottom.equalToSuperview().inset(16)
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
            make.leading.trailing.equalTo(inputBox)
            self.tableViewHeightConstraint = make.height.equalTo(0).constraint
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
        iconButton.setImage(isExpanded ? .arrowUp : .arrowDown, for: .normal)
        let height = CGFloat(menus.count) * 44 + tableView.contentInset.top + tableView.contentInset.bottom
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
        return menus.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as? DropDownBoxCell else {
            return UITableViewCell()
        }
        let isSelected = selectedIndex == indexPath.row
        cell.injection(with: menus[indexPath.row], isSelected: isSelected)
        cell.selectionStyle = .none
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        inputBox.textField.attributedText = .makeStyledString(font: .body, text: menus[indexPath.row], alignment: .left)
        inputBox.textField.sendActions(for: .editingChanged)
        toggleDropdown()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
