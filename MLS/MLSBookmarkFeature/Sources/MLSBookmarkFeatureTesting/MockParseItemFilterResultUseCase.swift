import MLSDictionaryFeatureInterface
import MLSBookmarkFeatureInterface

public final class MockParseItemFilterResultUseCase: ParseItemFilterResultUseCase {
    public var result: ItemFilterCriteria = ItemFilterCriteria(jobIds: [], startLevel: nil, endLevel: nil, categoryIds: [])

    public init() {}

    public func execute(results: [(String, String)]) -> ItemFilterCriteria {
        result
    }
}
