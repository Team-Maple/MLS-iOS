import RxSwift

public protocol UpdateNotificationAgreementUseCase {
    func execute(noticeAgreement: Bool, patchNoteAgreement: Bool, eventAgreement: Bool) -> Completable
}
