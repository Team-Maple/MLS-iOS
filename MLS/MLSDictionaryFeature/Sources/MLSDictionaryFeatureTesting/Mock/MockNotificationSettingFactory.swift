import MLSCore
import MLSMyPageFeatureInterface

public final class MockNotificationSettingFactory: NotificationSettingFactory {
    public init() {

    }

    public func make(isAgreeEventNotification: Bool, isAgreeNoticeNotification: Bool, isAgreePatchNoteNotification: Bool) -> BaseViewController {
        let viewcontroller = BaseViewController()
        viewcontroller.view.backgroundColor = .redMLS
        return viewcontroller
    }
}
