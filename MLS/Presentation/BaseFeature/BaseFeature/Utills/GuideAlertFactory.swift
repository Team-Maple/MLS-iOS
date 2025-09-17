import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

public enum GuideAlertFactory {
    private static var currentAlertView: GuideAlert?
    private static var dimmedView: UIView?
    private static var containerView: UIView?
    private static var disposeBag = DisposeBag()

    public static func show(
        mainText: String,
        ctaText: String,
        cancelText: String? = nil,
        ctaAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        guard currentAlertView == nil, dimmedView == nil else { return }
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else {
            return
        }

        let container = UIView(frame: window.bounds)
        window.addSubview(container)

        let dimmed = UIView()
        dimmed.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmed.alpha = 0
        container.addSubview(dimmed)
        dimmed.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let alert = GuideAlert(mainText: mainText, ctaText: ctaText, cancelText: cancelText)
        alert.alpha = 0
        container.addSubview(alert)
        alert.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }

        disposeBag = DisposeBag()

        alert.ctaButton.rx.tap
            .bind {
                dismiss()
                ctaAction()
            }
            .disposed(by: disposeBag)

        if let cancelButton = alert.cancelButton {
            cancelButton.rx.tap
                .bind {
                    dismiss()
                    cancelAction?()
                }
                .disposed(by: disposeBag)
        }

        currentAlertView = alert
        dimmedView = dimmed
        containerView = container

        UIView.animate(withDuration: 0.25) {
            dimmed.alpha = 1
            alert.alpha = 1
        }
    }

    public static func showAuthAlert(
        type: AuthGuideAlert.AuthGuideAlertType,
        ctaAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        guard currentAlertView == nil, dimmedView == nil else { return }
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else {
            return
        }

        let container = UIView(frame: window.bounds)
        window.addSubview(container)

        let dimmed = UIView()
        dimmed.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmed.alpha = 0
        container.addSubview(dimmed)
        dimmed.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let alert = AuthGuideAlert(type: type)
        alert.alpha = 0
        container.addSubview(alert)
        alert.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }

        disposeBag = DisposeBag()

        alert.ctaButton.rx.tap
            .bind {
                dismiss()
                ctaAction()
            }
            .disposed(by: disposeBag)

        if let cancelButton = alert.cancelButton {
            cancelButton.rx.tap
                .bind {
                    dismiss()
                    cancelAction?()
                }
                .disposed(by: disposeBag)
        }

        currentAlertView = alert
        dimmedView = dimmed
        containerView = container

        UIView.animate(withDuration: 0.25) {
            dimmed.alpha = 1
            alert.alpha = 1
        }
    }

    public static func dismiss() {
        guard let alert = currentAlertView,
              let dimmed = dimmedView,
              let container = containerView
        else { return }

        UIView.animate(withDuration: 0.25, animations: {
            alert.alpha = 0
            dimmed.alpha = 0
        }, completion: { _ in
            alert.removeFromSuperview()
            dimmed.removeFromSuperview()
            container.removeFromSuperview()
            currentAlertView = nil
            dimmedView = nil
            containerView = nil
            disposeBag = DisposeBag()
        })
    }
}
