import UIKit

import DesignSystem

import RxCocoa
import RxSwift
/*
 푸시 알림 설정이 허용된 경우의 뷰
 */
class NotificationSettingView: UIView {
    // MARK: - Properites
    public var disposeBag = DisposeBag()
    // MARK: - Type
    public enum Constant {
        static let iconInset: CGFloat = 10
        static let buttonSize: CGFloat = 44
        static let topMargin: CGFloat = 20
        static let viewHeight: CGFloat = 100
        static let subTextViewWidth: CGFloat = 220
        static let horizontalMargin: CGFloat = 16
        static let subTextTopMargin: CGFloat = 8
        static let spacerHeight: CGFloat = 10
    }
    // MARK: - Components
    // 헤더 뷰
    public let headerView = UIView()
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "arrowBack")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: Constant.iconInset, left: Constant.iconInset, bottom: Constant.iconInset, right: Constant.iconInset)), for: .normal)
        button.tintColor = .textColor
        return button
    }()
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .sub_m_b, text: "알림 설정")
        return label
    }()
    // 각종 알림설정 셀들 담을 스택뷰
    // 굳이 scrollView안에 안 넣어도 될 듯.
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 36
        return stackView
    }()

    // 콜백 클로저
    var onChangeButtonTapped: (() -> Void)?

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
private extension NotificationSettingView {
    func addViews() {
        [headerView, stackView].forEach { addSubview($0) }

        [backButton, titleLabel].forEach { headerView.addSubview($0) }
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
            make.verticalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing)
            make.verticalEdges.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constant.topMargin)
            make.width.equalToSuperview()
        }
    }
}

extension NotificationSettingView {

    func createNotificationView(titleText: String, subText: String, authorized: Bool) {
        let itemView = NotificationItemView(title: titleText, subtitle: subText, authorized: authorized)
         itemView.onChangeButtonTapped = { [weak self] in
             self?.onChangeButtonTapped?()
         }
         stackView.addArrangedSubview(itemView)
    }

    private func bindAction(button: UIButton) {
        button.rx.tap
            .bind { [weak self] in
                self?.onChangeButtonTapped?()
            }
            .disposed(by: disposeBag)
    }

    @objc private func changeButtonTapped() {
        onChangeButtonTapped?()
    }

    func clearNotificationViews() {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
