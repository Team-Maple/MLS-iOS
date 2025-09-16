import DomainInterface

import RxSwift

public class CheckNickNameUseCaseImpl: CheckNickNameUseCase {
    public init() {}

    public func execute(nickName: String) -> Observable<Bool> {
        return .just((nickName).contains("병"))
    }
}
