public protocol ParseItemFilterResultUseCase {
    func execute(results: [(String, String)]) -> ItemFilterCriteria
}
