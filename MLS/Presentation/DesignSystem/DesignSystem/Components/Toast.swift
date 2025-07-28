import UIKit

import SnapKit

public final class Toast: UIView {
    private enum Constant {
        static let verticalEdgesInset: CGFloat = 16
        static let horizontalEdges: CGFloat = 24
        static let cornerRadius: CGFloat = 8
    }

    // MARK: - Properties
//    public let blurView: UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
//        let view = UIVisualEffectView(effect: blurEffect)
//        view.backgroundColor = .clearMLS
//        view.clipsToBounds = true
//        view.layer.cornerRadius = Constant.cornerRadius
//        return view
//    }()

    private let toastContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral700.withAlphaComponent(0.8)
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
//        addSubview(blurView)
        addSubview(toastContentView)
        toastContentView.addSubview(label)
    }

    func setupConstraints() {
//        blurView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }

        toastContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constant.verticalEdgesInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalEdges)
        }
    }

    func configureUI(message: String?) {
        self.layer.cornerRadius = Constant.cornerRadius
        self.clipsToBounds = true
        self.label.attributedText = .makeStyledString(font: .caption, text: message, color: .white)
    }
}
