import UIKit



public class OpenNotificationSettingUseCaseImpl: OpenNotificationSettingUseCase {
    public init() {}

    public func execute() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
