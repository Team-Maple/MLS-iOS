struct SetBookmarkDTO: Decodable {
    let bookmarkId: Int
    let bookmarkType: String
    let resourceId: Int

    func toDomain() -> Int {
        return self.bookmarkId
    }
}
