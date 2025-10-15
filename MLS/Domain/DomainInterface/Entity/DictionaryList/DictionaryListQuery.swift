public struct DictionaryListQuery: Encodable {
    public var keyword: String?
    public var page: Int
    public var size: Int
    public var sort: String?
    
    // monster일 경우
    public var minLevel: Int?
    public var maxLevel: Int?
    
    // item일 경우
    public var jobId: Int?
    public var categoryIds: [Int]?
    
    public init(keyword: String? = nil, page: Int, size: Int, sort: String?, minLevel: Int? = nil, maxLevel: Int? = nil, jobId: Int? = nil, categoryIds: [Int]? = nil) {
        self.keyword = keyword
        self.page = page
        self.size = size
        self.sort = sort ?? "ASC"
        self.minLevel = minLevel
        self.maxLevel = maxLevel
        self.jobId = jobId
        self.categoryIds = categoryIds
    }
}
