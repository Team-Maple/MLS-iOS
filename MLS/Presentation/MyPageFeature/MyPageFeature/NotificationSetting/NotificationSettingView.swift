import UIKit

import DesignSystem

import RxCocoa
import RxSwift

final class NotificationSettingView: UIView {
    // MARK: - Properties
    public var disposeBag = DisposeBag()

    // MARK: - Constants
    public enum Constant {
        static let iconInset: CGFloat = 10
        static let buttonSize: CGFloat = 44
        static let topMargin: CGFloat = 20
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
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_b, text: "알림 설정")
        return label
    }()

    // 알림 설정 셀들을 담는 스택뷰
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [eventView, noticeView, patchNoteView, pushGuideView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 36
        return stackView
    }()

    public let eventView = NotificationItemView(title: "신규 이벤트 알림 설정", subtitle: "메이플랜드 신규 이벤트를 푸시 알림으로 빠르게 받을 수 있어요.", isAuth: true)

    public let noticeView = NotificationItemView(title: "공지사항 알림 설정", subtitle: "메이플랜드 공지사항을 푸시 알림으로 빠르게 받을 수 있어요.", isAuth: true)

    public let patchNoteView = NotificationItemView(title: "패치노트 알림 설정", subtitle: "메이플랜드 패치노트를 푸시 알림으로 빠르게 받을 수 있어요.", isAuth: true)

    public let pushGuideView = NotificationItemView(title: "푸시 알림 설정", subtitle: "기기 설정을 변경해야 알림을 받을 수 있어요.", isAuth: false)

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

// MARK: - Setup
private extension NotificationSettingView {
    func addViews() {
        addSubview(headerView)
        addSubview(stackView)

        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constant.buttonSize)
        }

        backButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(Constant.buttonSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing)
            make.centerY.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constant.topMargin)
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}

// MARK: - Update
extension NotificationSettingView {
    func setViews(authorized: Bool) {
        eventView.isHidden = !authorized
        noticeView.isHidden = !authorized
        patchNoteView.isHidden = !authorized
        pushGuideView.isHidden = authorized
    }
}
