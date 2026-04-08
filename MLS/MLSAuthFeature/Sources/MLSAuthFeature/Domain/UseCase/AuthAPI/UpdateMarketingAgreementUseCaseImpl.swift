import Foundation


import RxSwift

public class UpdateMarketingAgreementUseCaseImpl: UpdateMarketingAgreementUseCase {
    private let repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(credential: String, isMarketingAgreement: Bool) -> Completable {
        return repository.updateMarketingAgreement(credential: credential, isMarketingAgreement: isMarketingAgreement)
    }
}
