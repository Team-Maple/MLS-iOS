import MLSAuthFeatureInterface

import RxSwift

public class CheckValidLevelUseCaseImpl: CheckValidLevelUseCase {
    public init() {}

    public func execute(level: Int?) -> Bool? {
        guard let level = level else {
            return nil
        }
        return (1 ... 200).contains(level)
    }
}
