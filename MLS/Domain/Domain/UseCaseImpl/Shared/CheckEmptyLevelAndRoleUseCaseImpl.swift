import DomainInterface

import RxSwift

public class CheckEmptyLevelAndRoleUseCaseImpl: CheckEmptyLevelAndRoleUseCase {
    public init() {}

    public func execute(level: Int?, job: String?) -> Observable<Bool> {
        let isValidLevel = level.map { (1 ... 200).contains($0) } ?? false
        let isValidRole = job != nil && job != ""
        return .just(isValidLevel && isValidRole)
    }
}
