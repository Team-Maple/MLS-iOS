import UIKit

import SnapKit

final class DropDownBoxCell: UITableViewCell {
    // MARK: - Type
    private enum Constant {
        static var horizontalInset: CGFloat = 20
        static var verticalInset: CGFloat = 10
        static var cellInset: CGFloat = 4
        static var radius: CGFloat = 8
    }

    // MARK: - Components
    private let titleLabel = UILabel()

    private let backgroundColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constant.radius
        return view
    }()

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setupContstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension DropDownBoxCell {
    func addViews() {
        contentView.addSubview(backgroundColorView)
        backgroundColorView.addSubview(titleLabel)
    }

    func setupContstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.verticalEdges.equalToSuperview().inset(Constant.verticalInset)
        }

        backgroundColorView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.cellInset)
            make.verticalEdges.equalToSuperview()
        }
    }
}

extension DropDownBoxCell {
    func injection(with input: String, isSelected: Bool) {
        titleLabel.attributedText = .makeStyledString(font: .b_m_r, text: input, color: isSelected ? .textColor : .neutral500, alignment: .left)
        backgroundColorView.backgroundColor = isSelected ? .neutral100 : .clearMLS
    }
}
