public struct BookmarkRequestBody: Encodable {
    let bookmarkType: String
    let resourceId: Int
    
    public init(bookmarkType: String, resourceId: Int) {
        self.bookmarkType = bookmarkType
        self.resourceId = resourceId
    }
}
