import Foundation


import RxSwift

public class UpdateNotificationAgreementUseCaseImpl: UpdateNotificationAgreementUseCase {
    private let repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(noticeAgreement: Bool, patchNoteAgreement: Bool, eventAgreement: Bool) -> Completable {
        return repository.updateNotificationAgreement(noticeAgreement: noticeAgreement, patchNoteAgreement: patchNoteAgreement, eventAgreement: eventAgreement)
    }
}
