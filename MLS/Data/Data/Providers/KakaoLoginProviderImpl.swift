import Foundation

import DomainInterface

import KakaoSDKAuth
import KakaoSDKUser
import RxSwift

public final class KakaoLoginProviderImpl: SocialAuthenticatableProvider {
    public struct Credential: Encodable {
        var accessToken: String?
        var email: String?
    }

    public init() {}

    public func getCredential() -> Observable<Credential> {
        let observable = PublishSubject<Credential>()

        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 설치되어있을때
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                self.fetchEmail(oauthToken: oauthToken, error: error, observer: observable.asObserver())
            }
        } else {
            // 카카오톡이 설치되어있지않을때
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                self.fetchEmail(oauthToken: oauthToken, error: error, observer: observable.asObserver())
            }
        }

        return observable
        
//        return Observable.create { [weak self] observer in
//            if UserApi.isKakaoTalkLoginAvailable() {
//                // 카카오톡 설치되어있을때
//                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
//                    self?.fetchEmail(oauthToken: oauthToken, error: error, observer: observer)
//                }
//            } else {
//                // 카카오톡이 설치되어있지않을때
//                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
//                    self?.fetchEmail(oauthToken: oauthToken, error: error, observer: observer)
//                }
//            }
//            return Disposables.create()
//        }
    }

    private func fetchEmail(oauthToken: OAuthToken?, error: Error?, observer: AnyObserver<Credential>) {
        if let error = error {
            observer.onError(error)
            return
        }

        guard let accessToken = oauthToken?.accessToken else {
            observer.onError(AuthError.unknown(message: "토큰이 없어요"))
            return
        }

        UserApi.shared.me { user, error in
            if let error = error {
                observer.onError(error)
            } else {
                let credential = Credential(accessToken: accessToken, email: user?.kakaoAccount?.email)
                observer.onNext(credential)
                observer.onCompleted()
            }
        }
    }
}
