import UIKit

import SnapKit

public final class Toast: UIView {
    private enum Constant {
        static let horizontalEdges: CGFloat = 16
        static let height: CGFloat = 44
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
        self.toastContentView.addSubview(self.label)
    }

    func setupConstraints() {
        self.toastContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(Constant.height)
        }

        self.label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalEdges)
            make.centerY.equalToSuperview()
        }
    }

    func configureUI(message: String?) {
        layer.cornerRadius = Constant.cornerRadius
        clipsToBounds = true
        self.label.attributedText = .makeStyledString(font: .b_s_r, text: message, color: .whiteMLS)
    }
}
