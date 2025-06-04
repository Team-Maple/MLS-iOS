import UIKit

internal import SnapKit

public final class Toast: UIView {
    private struct Constant {
        static let verticalEdgesInset: CGFloat = 16
        static let horizontalEdges: CGFloat = 24
        static let cornerRadius: CGFloat = 8
    }

    // MARK: - Properties
    private let label: UILabel = UILabel()

    // MARK: - init
    public init(message: String?) {
        super.init(frame: .zero)

        self.addViews()
        self.setupConstraints()
        self.configureUI(message: message)
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension Toast {
    func addViews() {
        self.addSubview(label)
    }

    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constant.verticalEdgesInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalEdges)
        }
    }

    func configureUI(message: String?) {
        self.backgroundColor = .neutral700
        self.layer.cornerRadius = Constant.cornerRadius
        self.clipsToBounds = true
        self.label.attributedText = .makeStyledString(font: .caption, text: message, color: .white)
    }
}
