import DomainInterface

import RxSwift

public class CheckNickNameUseCaseImpl: CheckNickNameUseCase {
    public init() {}

    public func excute(nickName: String) -> Observable<Bool> {
        return .just(!(nickName).contains("병"))
    }
}
