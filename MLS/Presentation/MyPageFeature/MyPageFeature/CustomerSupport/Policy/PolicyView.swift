import UIKit

import DesignSystem
import MyPageFeatureInterface

final class PolicyView: UIView {
    // MARK: - Type
    public enum Constant {
        static let verticalMargin: CGFloat = 20
        static let horizontalMargin: CGFloat = 16
    }

    // MARK: - Components
    public let headerView = NavigationBar(type: .collection("약관 및 정책"))

    private let titleLabel = UILabel()

    private let contentTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = false
        view.isSelectable = false
        return view
    }()

    // MARK: - Init
    init(type: PolicyType) {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI(type: type)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension PolicyView {
    func addViews() {
        addSubview(headerView)
        addSubview(titleLabel)
        addSubview(contentTextView)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constant.verticalMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
        }

        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.verticalMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
            make.bottom.equalToSuperview().inset(Constant.verticalMargin)
        }
    }

    func configureUI(type: PolicyType) {
        headerView.editButton.isHidden = true
        headerView.addButton.isHidden = true
        headerView.setTitle(title: type.title)
        titleLabel.attributedText = .makeStyledString(font: .h_xxxl_sb, text: "메랜사 \(type.title)", alignment: .left)

        let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineBreakMode = .byWordWrapping
           paragraphStyle.alignment = .left

           let attrString = NSAttributedString(
               string: type.content,
               attributes: [
                .font: UIFont.b_s_r ?? .systemFont(ofSize: 12),
                   .foregroundColor: UIColor.textColor,
                   .paragraphStyle: paragraphStyle
               ]
           )

           contentTextView.attributedText = attrString
    }
}
