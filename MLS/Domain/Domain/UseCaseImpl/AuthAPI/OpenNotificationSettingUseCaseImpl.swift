import UIKit

import DomainInterface

public final class OpenNotificationSettingUseCaseImpl: OpenNotificationSettingUseCase {
    public init() {}

    public func execute() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
