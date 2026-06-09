import Foundation
import os

import MLSAuthFeatureInterface
import MLSCore

public final class TokenLauncher {
    private let tokenRepository: TokenRepository

    public init(tokenRepository: TokenRepository = DIContainer.resolve(type: TokenRepository.self)) {
        self.tokenRepository = tokenRepository
    }

    public func didReceiveFCMToken(_ token: String) {
        let dataDict: [String: String] = [
            "token": token
        ]

        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )

        let saveResult = tokenRepository.saveToken(
            type: .fcmToken,
            value: token
        )

        switch saveResult {
        case .success:
            os_log("fcmToken Save Success: \(token)")
        case .failure:
            os_log("fcmToken Save Failure")
        }

        if case .success(let accessToken) =
            tokenRepository.fetchToken(type: .accessToken),
            !accessToken.isEmpty
        {
            _ = tokenRepository.saveToken(
                type: .fcmToken,
                value: token
            )

            os_log("Request to update FCM token on server")
        } else {
            os_log("Not logged in yet, skipping FCM update to server")
        }
    }
}
