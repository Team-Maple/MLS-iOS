import MLSAuthFeatureInterface

public class CheckValidLevelUseCaseImpl: CheckValidLevelUseCase {
    public init() {}

    public func execute(level: Int?) -> Bool? {
        guard let level else { return nil }
        return (1 ... 200).contains(level)
    }
}
