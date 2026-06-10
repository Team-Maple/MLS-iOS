import UIKit

import MLSAppFeatureInterface
import MLSAuthFeatureInterface
import MLSCore
import MLSDesignSystem

import RxSwift

@MainActor
public final class AppLauncher {
    private let disposeBag = DisposeBag()
    private var forceUpdateObserver: NSObjectProtocol?

    public init() {}

    public func launch(window: UIWindow?) {
        DependencyAssembler.launch(window: window)

        let tokenRepository = DIContainer.resolve(type: TokenRepository.self)
        let authRepository = DIContainer.resolve(type: AuthAPIRepository.self)

        switch tokenRepository.fetchToken(type: .refreshToken) {
        case .success(let refreshToken):
            #if DEBUG
            print("refreshToken: \(refreshToken)")
            #endif
            authRepository.reissueToken(refreshToken: refreshToken)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] _ in
                    Task { @MainActor in
                        let coordinator = DIContainer.resolve(type: AppCoordinatorProtocol.self)
                        coordinator.showMainTab()
                        self?.checkUpdateIfNeeded()
                    }
                },
                onError: { [weak self] _ in
                    Task { @MainActor in
                        let coordinator = DIContainer.resolve(type: AppCoordinatorProtocol.self)
                        coordinator.showLogin(exitRoute: .home)
                        self?.checkUpdateIfNeeded()
                    }
                }
            )
            .disposed(by: disposeBag)

        case .failure:
            let coordinator = DIContainer.resolve(type: AppCoordinatorProtocol.self)
            coordinator.showLogin(exitRoute: .home)
            checkUpdateIfNeeded()
        }
    }

    public func register() {
        DependencyAssembler.register()
    }
}

// MARK: - Update Check
private extension AppLauncher {
    func checkUpdateIfNeeded() {
        guard
            let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let currentVersion = Version(versionString: versionString)
        else { return }

        Task { @MainActor in
            let useCase = DIContainer.resolve(type: UpdateCheckerUseCaseProtocol.self)
            guard let status = try? await useCase.checkUpdate(currentVersion: currentVersion) else { return }

            switch status {
            case .force:
                showForceUpdateAlert()
                if let existingObserver = forceUpdateObserver {
                    NotificationCenter.default.removeObserver(existingObserver)
                }
                forceUpdateObserver = NotificationCenter.default.addObserver(
                    forName: UIApplication.didBecomeActiveNotification,
                    object: nil,
                    queue: .main
                ) { [weak self] _ in
                    self?.showForceUpdateAlert()
                }
            case .optional(let latestVersion):
                GuideAlertFactory.show(
                    mainText: "앱 버전이 달라요.\n보다 좋은 서비스를 위해 업데이트 해주세요.",
                    ctaText: "업데이트 하기",
                    cancelText: "나중에",
                    ctaAction: { [weak self] in self?.openAppStore() },
                    cancelAction: { useCase.skipUpdate(version: latestVersion) }
                )
            case .none:
                break
            }
        }
    }

    func showForceUpdateAlert() {
        GuideAlertFactory.show(
            mainText: "앱 버전이 달라요.\n보다 좋은 서비스를 위해 업데이트 해주세요.",
            ctaText: "업데이트 하기",
            cancelText: nil,
            ctaAction: { [weak self] in self?.openAppStore() }
        )
    }

    func openAppStore() {
        guard let url = URL(string: AppInfo.appStoreURL) else {
            showForceUpdateAlert()
            return
        }
        UIApplication.shared.open(url, options: [:]) { [weak self] success in
            if !success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.showForceUpdateAlert()
                }
            }
        }
    }
}
