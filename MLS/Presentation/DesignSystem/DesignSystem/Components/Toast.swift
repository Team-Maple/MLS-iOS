import UIKit

import SnapKit

public final class Toast: UIView {
    private enum Constant {
        static let verticalEdgesInset: CGFloat = 16
        static let horizontalEdges: CGFloat = 16
        static let cornerRadius: CGFloat = 8
    }

    // MARK: - Properties
    private let toastContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral900
        return view
    }()

    private let label: UILabel = .init()

    // MARK: - init
    public init(message: String?) {
        super.init(frame: .zero)

        self.addViews()
        self.setupConstraints()
        self.configureUI(message: message)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension Toast {
    func addViews() {
        addSubview(self.toastContentView)
        toastContentView.addSubview(self.label)
    }

    func setupConstraints() {
        toastContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constant.verticalEdgesInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalEdges)
        }
    }

    func configureUI(message: String?) {
        layer.cornerRadius = Constant.cornerRadius
        clipsToBounds = true
        label.attributedText = .makeStyledString(font: .b_s_r, text: message, color: .whiteMLS)
    }
}
