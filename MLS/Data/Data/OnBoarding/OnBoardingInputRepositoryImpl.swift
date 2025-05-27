import DomainInterface

import RxSwift

public class OnBoardingInputRepositoryImpl: OnBoardingInputRepository {
    public func checkEmptyData(level: Int?, role: String?) -> Observable<Bool> {
        let isValidLevel = level.map { (0 ... 200).contains($0) } ?? false
        let isValidRole = role != nil
        return .just(isValidLevel && isValidRole)
    }

    public func checkValidLevel(level: Int?) -> Observable<Bool> {
        guard let level = level else {
            return .just(false)
        }
        return .just((0 ... 200).contains(level))
    }
}
