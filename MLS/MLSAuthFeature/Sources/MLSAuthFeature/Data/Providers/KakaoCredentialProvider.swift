import Foundation

import MLSAuthFeatureInterface

import KakaoSDKAuth
import KakaoSDKUser
import RxSwift

public final class KakaoCredentialProvider: SocialCredentialProvider, @unchecked Sendable {
    public init() {}

    public func getCredential() -> Observable<Credential> {
        return Observable.create { [weak self] observer in
            let disposable = Disposables.create()

            let handleLogin: (OAuthToken?, Error?) -> Void = { oauthToken, error in
                self?.fetchEmailAfterDelay(oauthToken: oauthToken, error: error, observer: observer)
            }

            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk(completion: handleLogin)
                } else {
                    UserApi.shared.loginWithKakaoAccount(completion: handleLogin)
                }
            }

            return disposable
        }
    }

    private func fetchEmailAfterDelay(oauthToken: OAuthToken?, error: Error?, observer: AnyObserver<Credential>) {
        if let error {
            observer.onError(error)
            return
        }

        guard let accessToken = oauthToken?.accessToken else {
            observer.onError(AuthError.unknown(message: "토큰이 없어요"))
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UserApi.shared.me { user, error in
                if let error {
                    observer.onError(error)
                    return
                }

                let id = user?.id ?? 0
                let credential = KakaoCredential(token: accessToken, providerID: String(id))
                observer.onNext(credential)
                observer.onCompleted()
            }
        }
    }
}
