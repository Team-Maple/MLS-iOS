import Foundation
import AuthenticationServices

import DomainInterface

import RxSwift

public final class AppleLoginProvider: NSObject, SocialAuthenticatable {
    
    public struct Credential: Encodable {
        var idToken: String?
        var authorizationCode: String?
    }
    
    private let authServiceResponse = PublishSubject<Credential>()
    
    public func getCredential() -> Observable<Credential> {
        performRequest()
        return authServiceResponse
    }
    
    private func performRequest() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

// MARK: - Delegate
extension AppleLoginProvider: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first ?? UIWindow()
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            authServiceResponse.onError(AuthError.unknown(message: "Invalid Apple credential"))
            return
        }

        guard let idTokenData = appleIDCredential.identityToken,
              let idToken = String(data: idTokenData, encoding: .utf8),
              let codeData = appleIDCredential.authorizationCode,
              let authCode = String(data: codeData, encoding: .utf8)
        else {
            authServiceResponse.onError(AuthError.unknown(message: "Failed to parse Apple token or code"))
            return
        }

        let credential = Credential(idToken: idToken, authorizationCode: authCode)
        authServiceResponse.onNext(credential)
        authServiceResponse.onCompleted()
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authServiceResponse.onError(error)
    }
}
