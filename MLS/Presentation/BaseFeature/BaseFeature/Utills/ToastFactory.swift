import UIKit

import DesignSystem

import RxSwift
import SnapKit

public final class ToastFactory {

    // MARK: - Properties

    /// 현재 디바이스 최상단 Window를 지정
    static var window: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }

    /// 최상단의 ViewController를 가져오는 메서드
    private static func topViewController(
        _ rootViewController: UIViewController? = window?.rootViewController
    ) -> UIViewController? {
        if let navigationController = rootViewController as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        if let tabBarController = rootViewController as? UITabBarController {
            return topViewController(tabBarController.selectedViewController)
        }
        if let presentedViewController = rootViewController?.presentedViewController {
            return topViewController(presentedViewController)
        }
        return rootViewController
    }

    private static var currentToast: Toast?
    private static var disposeBag = DisposeBag()
}

extension ToastFactory {

    // MARK: - Method

    /// 토스트 메시지를 생성하는 메서드
    /// - Parameter message: 토스트 메세지에 담길 String 타입
    public static func createToast(message: String) {

        currentToast?.removeFromSuperview()
        currentToast = nil
        let toastMSG = Toast(message: message)
        guard let window = window else { return }
        window.addSubview(toastMSG)
        currentToast = toastMSG

        toastMSG.snp.makeConstraints { make in
            make.bottom.equalTo(window.snp.bottom).inset(120)
            make.centerX.equalTo(window.snp.centerX)
        }

        toastMSG.alpha = 0
        UIView.animate(withDuration: 0.25) {
            toastMSG.alpha = 1
        }

        UIView.animate(
            withDuration: 0.6,
            delay: 2.3,
            options: .curveEaseOut
        ) {
            toastMSG.alpha = 0
        } completion: { _ in
            toastMSG.removeFromSuperview()
            if currentToast == toastMSG { currentToast = nil }
        }
    }
}
