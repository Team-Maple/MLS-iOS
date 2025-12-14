import UIKit

import DesignSystem
/*
 **고객지원 공통뷰가 될 것 같음**
 */
final class CustomerSupportBaseView: UIView {
    // MARK: - Type
    public enum Constant {
        static let iconInset: CGFloat = 10
        static let buttonSize: CGFloat = 44
        static let horizontalInset: CGFloat = 16
        static let topMargin: CGFloat = 20
        static let menuStackViewHeight: CGFloat = 40
        static let underlineHeight: CGFloat = 2
        static let spacerHeight: CGFloat = 1
        static let imageSize: CGFloat = 20
        static let textWidth: CGFloat = 300
        static let viewHeight: CGFloat = 86
        static let dateTopMargin: CGFloat = 4
        static let emptyLabelHeight: CGFloat = 86
        static let emptyLabelInset: CGFloat = 16

        static let menuTabBarButtonInset: NSDirectionalEdgeInsets = .init(top: 9, leading: 4, bottom: 9, trailing: 4)
        static let menuTabBarHorizontalInset: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    // MARK: - Components
    // 헤더 뷰
    public let headerView = UIView()

    public let backButton: UIButton = {
        let button = UIButton()
        button
            .setImage(
                DesignSystemAsset
                    .image(named: "arrowBack")?
                    .withRenderingMode(.alwaysTemplate)
                    .resizableImage(
                        withCapInsets: UIEdgeInsets(
                            top: Constant.iconInset,
                            left: Constant.iconInset,
                            bottom: Constant.iconInset,
                            right: Constant.iconInset
                        )
                    ),
                for: .normal
            )
        button.tintColor = .textColor
        return button
    }()

    public let titleLabel = UILabel()

    let menuContainerView = UIView()

    // 이벤트 메뉴(진행중, 종료) 스택 뷰
    let menuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.menuTabBarHorizontalInset
        return stackView
    }()

    let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral300
        return view
    }()

    // 메뉴 스택뷰 왼쪽 정렬을 위해서
    let emptyView = UIView()

    /// 아이템 스 택뷰 담을 스크롤 뷰
    public let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    // 아이템 담을 스택 뷰
    let detailItemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.menuTabBarHorizontalInset
        return stackView
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension CustomerSupportBaseView {
    func addViews() {
        [backButton, titleLabel].forEach { headerView.addSubview($0) }
        [headerView, menuContainerView, scrollView].forEach { addSubview($0) }
        scrollView.addSubview(detailItemStackView)
        menuContainerView.addSubview(menuStackView)
        menuContainerView.addSubview(bottomLineView)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constant.buttonSize)
        }

        backButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(Constant.buttonSize)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing)
            make.centerY.equalToSuperview()
        }

        menuContainerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constant.topMargin)
            make.width.equalToSuperview()
            make.height.equalTo(Constant.menuStackViewHeight)
        }
        menuStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(Constant.menuStackViewHeight)
            make.edges.equalToSuperview()
        }

        bottomLineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(Constant.spacerHeight)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(menuContainerView.snp.bottom)
            make.width.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        detailItemStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension CustomerSupportBaseView {
    func createMenuButton(title: String, tag: Int) -> UIButton {
        let config = setupConfig()
        let button = UIButton(configuration: config)
        button.setAttributedTitle(.makeStyledString(font: .b_m_r, text: title), for: .normal)
        button.setTitleColor(.neutral600, for: .normal)
        button.titleLabel?.font = UIFont.b_m_r
        button.tag = tag

        let underline = UIView()
        underline.backgroundColor = .textColor
        underline.isHidden = true
        underline.tag = 999999

        button.addSubview(underline)
        underline.snp.makeConstraints { make in
            make.height.equalTo(Constant.underlineHeight)
            make.leading.trailing.bottom.equalToSuperview()
        }
        return button
    }

    func setupConfig() -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = Constant.menuTabBarButtonInset
        return config
    }

    func createDetailItem(titleText: String, dateText: String?) -> UIView { // 제목, 날짜 데이터 필요
        let view = UIView()
        let title = UILabel()
        let date = UILabel()
        let spacer = UIView()
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.image(named: "arrowForwardSmall")

        title.attributedText = .makeStyledString(font: .sub_m_sb, text: titleText)
        title.textAlignment = .left

        date.attributedText = .makeStyledString(font: .b_s_r, text: dateText, color: .neutral700)

        view.addSubview(title)
        view.addSubview(date)
        view.addSubview(imageView)

        spacer.backgroundColor = UIColor.neutral200

        view.snp.makeConstraints { make in
            make.height.equalTo(Constant.viewHeight)
        }
        if dateText != nil {
            title.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(Constant.topMargin)
                // 임의 너비 설정
                make.width.equalTo(Constant.textWidth)
            }
            date.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(Constant.dateTopMargin)
            }
        } else {
            title.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(Constant.textWidth)
            }
        }
        imageView.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        spacer.snp.makeConstraints { make in
            make.height.equalTo(Constant.spacerHeight)
        }

        detailItemStackView.addArrangedSubview(view)
        detailItemStackView.addArrangedSubview(spacer)

        return view
    }

    func setupSpacerView() {
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        menuStackView.addArrangedSubview(spacerView)
    }

    // 이벤트 뷰가 아닐 경우 메뉴 태그 필요없음 -> 제약사항 변경 되어야 함
    func changeSetupConstraints() {
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constant.topMargin)
            make.width.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        setMenuHidden(true) // menuContainer뷰 숨기기
    }

    // menuContainerView Encapsulation
    func setMenuHidden(_ hidden: Bool) {
        menuContainerView.isHidden = hidden
    }

    func setEmpty(text: String) {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_m_r, text: text, color: .neutral700, alignment: .left)
        let view = UIView()

        view.addSubview(label)

        view.snp.makeConstraints { make in
            make.height.equalTo(Constant.emptyLabelHeight)
        }
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.emptyLabelInset)
            make.centerY.equalToSuperview()
        }
        detailItemStackView.addArrangedSubview(view)
    }
}
