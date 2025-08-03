import UIKit

import SnapKit

public final class ErrorMessage: UIView {
    private enum Constant {
        static let verticalEdgesInset: CGFloat = 8
        static let horizontalEdges: CGFloat = 20
        static let cornerRadius: CGFloat = 18
        static let spacing: CGFloat = 4
        static let height: CGFloat = 36
        static let iconSize: CGFloat = 16
    }

    // MARK: - Properties
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = .error
        return view
    }()

    public let label = UILabel()

    // MARK: - init
    public init(message: String?) {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI(message: message)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension ErrorMessage {
    func addViews() {
        addSubview(iconView)
        addSubview(label)
    }

    func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }

        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constant.horizontalEdges)
            make.size.equalTo(Constant.iconSize)
        }

        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constant.verticalEdgesInset)
            make.leading.equalTo(self.iconView.snp.trailing).offset(Constant.spacing)
            make.trailing.equalToSuperview().inset(Constant.horizontalEdges)
        }
    }

    func configureUI(message: String?) {
        self.backgroundColor = .error100
        self.layer.cornerRadius = Constant.cornerRadius
        self.clipsToBounds = true
        self.label.attributedText = .makeStyledString(font: .b_s_r, text: message, color: .error900)
    }
}
