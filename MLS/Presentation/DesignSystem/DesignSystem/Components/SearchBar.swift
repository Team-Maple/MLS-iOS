import UIKit

import SnapKit

public protocol SearchBarDelegate: AnyObject {
    func searchBarDidReturn(_ searchBar: SearchBar, text: String)
}

public final class SearchBar: UIView {
    // MARK: - Properties
    public weak var searchDelegate: SearchBarDelegate?

    // MARK: - Components
    public let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = DesignSystemAsset.image(named: "arrowBack")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .textColor
        return button
    }()

    public let textField: UITextField = {
        let textField = UITextField()
        textField.font = .b_l_r
        textField.textColor = .textColor
        textField.attributedPlaceholder = .makeStyledString(font: .b_l_r, text: "찾는 정보를 검색해 보세요", color: .neutral300)
        textField.textAlignment = .left
        textField.tintColor = .primary300
        textField.returnKeyType = .search
        return textField
    }()

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 8
        return view
    }()

    public let searchButton: UIButton = {
        let button = UIButton(type: .system)
        let image = DesignSystemAsset.image(named: "search")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .textColor
        return button
    }()

    public let clearButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = DesignSystemAsset.image(named: "textFieldClear")
        button.setImage(image, for: .normal)
        button.isHidden = true
        return button
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral300
        return view
    }()

    private let fillLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary700
        view.transform = CGAffineTransform(scaleX: 0, y: 1)
        return view
    }()

    // MARK: - init
    public init() {
        super.init(frame: .zero)

        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension SearchBar {
    func addViews() {
        addSubview(contentStackView)
        addSubview(lineView)
        lineView.addSubview(fillLineView)

        contentStackView.addArrangedSubview(backButton)
        contentStackView.addArrangedSubview(textField)
        contentStackView.addArrangedSubview(clearButton)
        contentStackView.addArrangedSubview(searchButton)
    }

    func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        backButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        searchButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        textField.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        clearButton.snp.makeConstraints { make in
            make.size.equalTo(19)
        }
        fillLineView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        textField.delegate = self
        clearButton.addAction(.init(handler: { [weak self] _ in self?.textField.text = "" }), for: .touchUpInside)
        searchButton.addAction(.init(handler: { [weak self] _ in self?.endEditing(true) }), for: .touchUpInside)
    }
}

extension SearchBar: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        clearButton.isHidden = (textField.text ?? "").isEmpty
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseOut]) {
            self.fillLineView.transform = CGAffineTransform.identity
        }
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        clearButton.isHidden = true
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseIn]) {
            self.fillLineView.transform = CGAffineTransform(scaleX: 0.001, y: 1)
        } completion: { _ in
            self.fillLineView.transform = CGAffineTransform(scaleX: 0, y: 1)
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchDelegate?.searchBarDidReturn(self, text: textField.text ?? "")

        endEditing(true)
        clearButton.isHidden = true
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        clearButton.isHidden = updatedText.isEmpty || !textField.isFirstResponder
        return true
    }
}
