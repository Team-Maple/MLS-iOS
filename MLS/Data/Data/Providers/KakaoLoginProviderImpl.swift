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

    /// 카카오에 요청을 보내서 access 토큰을 포함한 정보를 가져오는 함수
    /// - Returns: accessToken + email
    public func getCredential() -> Observable<Credential> {
        return Observable.create { [weak self] observer in

            let disposable = Disposables.create()

            if UserApi.isKakaoTalkLoginAvailable() {
                // 카카오톡이 설치되어있을때 (앱)
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    self?.fetchEmail(oauthToken: oauthToken, error: error, observer: observer)
                }
            } else {
                // 카카오톡이 설치되어있지않을때 (웹)
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    self?.fetchEmail(oauthToken: oauthToken, error: error, observer: observer)
                }
            }

            return disposable
        }
    }
    
    /// access 토큰을 이용하여 email 정보를 가져오는 함수
    /// - Parameters:
    ///   - oauthToken: accessToken을 포함한 OAuthToken
    ///   - error: 발생한 에러
    ///   - observer: Credential을 관리하는 스트림
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
