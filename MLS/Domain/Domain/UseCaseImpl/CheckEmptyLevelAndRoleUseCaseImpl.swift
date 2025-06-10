import DomainInterface

import RxSwift

public class CheckEmptyLevelAndRoleUseCaseImpl: CheckEmptyLevelAndRoleUseCase {
    public init() {}

    public func excute(level: Int?, role: String?) -> Observable<Bool> {
        let isValidLevel = level.map { (1 ... 200).contains($0) } ?? false
        let isValidRole = role != nil && role != ""
        return .just(isValidLevel && isValidRole)
    }
}
