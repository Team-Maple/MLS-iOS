import DomainInterface

import RxSwift

public class CheckValidLevelUseCaseImpl: CheckValidLevelUseCase {
    public init() {}
    
    public func excute(level: Int?) -> Observable<Bool?> {
        guard let level = level else {
            return .just(nil)
        }
        return .just((0 ... 200).contains(level))
    }
}
