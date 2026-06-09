import UIKit

import MLSAppFeatureInterface
import MLSAuthFeatureInterface
import MLSCore

import RxSwift

@MainActor
public final class AppLauncher {
    private let disposeBag = DisposeBag()

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
                onNext: { _ in
                    Task { @MainActor in
                        let coordinator = DIContainer.resolve(type: AppCoordinatorProtocol.self)
                        coordinator.showMainTab()
                    }
                },
                onError: { _ in
                    Task { @MainActor in
                        let coordinator = DIContainer.resolve(type: AppCoordinatorProtocol.self)
                        coordinator.showLogin(exitRoute: .home)
                    }
                }
            )
            .disposed(by: disposeBag)

        case .failure:
            let coordinator = DIContainer.resolve(type: AppCoordinatorProtocol.self)
            coordinator.showLogin(exitRoute: .home)
        }
    }

    public func register() {
        DependencyAssembler.register()
    }
}
