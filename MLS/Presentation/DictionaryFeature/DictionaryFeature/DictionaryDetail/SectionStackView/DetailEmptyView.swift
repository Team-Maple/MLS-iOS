import DomainInterface
import UIKit

import DesignSystem

import SnapKit

final class DetailEmptyView: UIView {
    // MARK: - Type
    private enum Constant {
        static let topSpacing: CGFloat = 20
        static let filterSpacing: CGFloat = 12
        static let cardHorizontalInset: CGFloat = 16
        static let filterContainerHeight: CGFloat = 28
        static let filterContainerTopMargin: CGFloat = 12
        static let filterButtonTrailing: CGFloat = 8
        static let viewSpacing: CGFloat = 10
    }

    // MARK: - Components
    let textLabel = UILabel()

    // MARK: - Init
    init(type: DetailType) {
        super.init(frame: .zero)
        addViews()
        setUpConstraints()
        setTextLabel(type: type)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DetailEmptyView {
    func addViews() {
        addSubview(textLabel)
    }

    func setUpConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func setTextLabel(type: DetailType) {
        textLabel.attributedText = .makeStyledString(font: .b_s_r, text: "\(type.description) 정보가 존재하지 않습니다.", color: .neutral600)
    }
}
