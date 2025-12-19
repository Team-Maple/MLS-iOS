import DomainInterface

public struct DictionaryDetailItemResponseDTO: Decodable {
    public let itemId: Int
    public let nameKr: String?
    public let nameEn: String?
    public let descriptionText: String?
    public let itemImageUrl: String?
    public let npcPrice: Int?
    public let itemType: String?
    public let categoryHierachy: CategoryHierachy?
    public let availableJobs: [Jobs]?
    public let requiredStats: RequiredStats? // 요구 스탯
    public let equipmentStats: EquipmentStats? // 착용하면 올라가는 스탯
    public let scrollDetail: ScrollDetail? // 주문서 상세정보
    public let bookmarkId: Int?

    public func toDomain() -> DictionaryDetailItemResponse {
        return DictionaryDetailItemResponse(
            itemId: itemId,
            nameKr: nameKr,
            nameEn: nameEn,
            descriptionText: descriptionText,
            imgUrl: itemImageUrl,
            npcPrice: npcPrice,
            itemType: itemType,
            categoryHierachy: categoryHierachy,
            availableJobs: availableJobs,
            requiredStats: requiredStats,
            equipmentStats: equipmentStats,
            scrollDetail: scrollDetail,
            bookmarkId: bookmarkId
        )
    }
}
