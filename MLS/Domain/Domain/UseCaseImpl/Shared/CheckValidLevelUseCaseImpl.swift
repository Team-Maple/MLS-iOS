import DomainInterface

import RxSwift

public class CheckValidLevelUseCaseImpl: CheckValidLevelUseCase {
    public init() {}

    public func execute(level: Int?) -> Observable<Bool?> {
        guard let level = level else {
            return .just(nil)
        }
        return .just((1 ... 200).contains(level))
    }
}
