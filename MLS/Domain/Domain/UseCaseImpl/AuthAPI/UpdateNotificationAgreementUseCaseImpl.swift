import DomainInterface

import RxSwift

public class UpdateNotificationAgreementUseCaseImpl: UpdateNotificationAgreementUseCase {
    private let repository: AuthAPIRepository

    public init(authRepository: AuthAPIRepository) {
        self.repository = authRepository
    }

    public func execute(noticeAgreement: Bool, patchNoteAgreement: Bool, eventAgreement: Bool) -> Completable {
        return repository.updateNotificationAgreement(noticeAgreement: noticeAgreement, patchNoteAgreement: patchNoteAgreement, eventAgreement: eventAgreement)
    }
}
