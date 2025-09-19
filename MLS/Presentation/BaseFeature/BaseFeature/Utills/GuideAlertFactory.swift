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
        let alert = GuideAlert(mainText: mainText, ctaText: ctaText, cancelText: cancelText)
        presentAlert(alert: alert, ctaAction: ctaAction, cancelAction: cancelAction)
    }

    public static func showAuthAlert(
        type: AuthGuideAlert.AuthGuideAlertType,
        ctaAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        let alert = AuthGuideAlert(type: type)
        presentAlert(alert: alert, ctaAction: ctaAction, cancelAction: cancelAction)
    }

    private static func presentAlert(
        alert: GuideAlert,
        ctaAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        guard currentAlertView == nil, dimmedView == nil else { return }
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }

        let container = UIView(frame: window.bounds)
        window.addSubview(container)

        let dimmed = UIView()
        dimmed.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmed.alpha = 0
        container.addSubview(dimmed)
        dimmed.snp.makeConstraints { $0.edges.equalToSuperview() }

        alert.alpha = 0
        container.addSubview(alert)
        alert.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
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
