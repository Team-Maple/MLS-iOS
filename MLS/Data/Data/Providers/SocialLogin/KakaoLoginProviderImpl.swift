import Foundation

import DomainInterface

import KakaoSDKAuth
import KakaoSDKUser
import RxSwift

public final class KakaoLoginProviderImpl: SocialAuthenticatableProvider {
    public init() {}

    public func getCredential() -> Observable<Credential> {
        return Observable.create { [weak self] observer in
            let disposable = Disposables.create()

            let handleLogin: (OAuthToken?, Error?) -> Void = { oauthToken, error in
                self?.fetchEmailAfterDelay(oauthToken: oauthToken, error: error, observer: observer)
            }

            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    // 카카오톡 앱 로그인
                    UserApi.shared.loginWithKakaoTalk(completion: handleLogin)
                } else {
                    // 웹 브라우저 로그인
                    UserApi.shared.loginWithKakaoAccount(completion: handleLogin)
                }
            }

            return disposable
        }
    }

    /// accessToken 기반으로 사용자 정보를 가져오는 함수 (딜레이 포함)
    private func fetchEmailAfterDelay(oauthToken: OAuthToken?, error: Error?, observer: AnyObserver<Credential>) {
        if let error = error {
            observer.onError(error)
            return
        }

        guard let accessToken = oauthToken?.accessToken else {
            observer.onError(AuthError.unknown(message: "토큰이 없어요"))
            return
        }

        // ✅ Kakao SDK 내부 토큰 저장 시간 보장
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UserApi.shared.me { user, error in
                if let error = error {
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
