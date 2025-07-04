import UIKit

import DesignSystem

import RxSwift
import SnapKit

public final class SnackBarFactory {

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

    private static var currentSnackBar: SnackBar?
    private static var disposeBag = DisposeBag()
}

extension SnackBarFactory {

    // MARK: - Method

    /// SnackBar를 생성하는 메소드
    /// - Parameters:
    ///   - type: normal / delete
    ///   - image: 스낵바 이미지
    ///   - imageBackgroundColor: 이미지 배경색상
    ///   - text: 스낵바에 들어갈 내용
    ///   - buttonText: 버튼 제목
    ///   - buttonAction: 버튼이 눌렸을때의 액션
    public static func createSnackBar(
        type: SnackBar.SnackBarType,
        image: UIImage?,
        imageBackgroundColor: UIColor,
        text: String,
        buttonText: String,
        buttonAction: (() -> Void)?
    ) {
         currentSnackBar?.removeFromSuperview()
         currentSnackBar = nil

         let snackBar = SnackBar(
             type: type,
             image: image,
             imageBackgroundColor: imageBackgroundColor,
             text: text,
             buttonText: buttonText,
             buttonAction: buttonAction
         )
         snackBar.alpha = 0

         guard let window = window else { return }
         window.addSubview(snackBar)
         currentSnackBar = snackBar

         snackBar.snp.makeConstraints { make in
             make.bottom.equalTo(window.safeAreaLayoutGuide.snp.bottom).inset(24)
             make.centerX.equalToSuperview()
         }

         UIView.animate(withDuration: 0.3) {
             snackBar.alpha = 1
         }

         DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
             UIView.animate(withDuration: 0.3, animations: {
                 snackBar.alpha = 0
             }, completion: { _ in
                 snackBar.removeFromSuperview()
                 if currentSnackBar == snackBar {
                     currentSnackBar = nil
                 }
             })
         }
     }
}
