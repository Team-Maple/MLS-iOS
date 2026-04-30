import MLSCore

public protocol NotificationSettingFactory {
    func make(isAgreeEventNotification: Bool, isAgreeNoticeNotification: Bool, isAgreePatchNoteNotification: Bool) -> BaseViewController
}
