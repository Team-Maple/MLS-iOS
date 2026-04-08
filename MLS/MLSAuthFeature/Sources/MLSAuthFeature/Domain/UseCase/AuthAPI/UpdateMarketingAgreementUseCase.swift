import RxSwift

public protocol UpdateMarketingAgreementUseCase {
    func execute(credential: String, isMarketingAgreement: Bool) -> Completable
}
