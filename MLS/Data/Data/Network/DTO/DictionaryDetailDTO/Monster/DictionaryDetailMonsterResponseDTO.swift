import DomainInterface

public struct DictionaryDetailMonsterResponseDTO: Decodable {
    public let monsterId: Int
    public let nameKr: String
    public let nameEn: String
    public let imageUrl: String
    public let level: Int
    public let exp: Int
    public let hp: Int
    public let mp: Int
    public let physicalDefense: Int
    public let magicDefense: Int
    public let requiredAccuracy: Int
    public let bonusAccuracyPerLevelLower: Double
    public let evasionRate: Int
    public let mesoDropAmount: Int?
    public let mesoDropRate: Int?
    public let typeEffectiveness: Effectiveness?
    public let bookmarkId: Int?

    public func toDomain() -> DictionaryDetailMonsterResponse {
        return DictionaryDetailMonsterResponse(
            monsterId: monsterId,
            nameKr: nameKr,
            nameEn: nameEn,
            imageUrl: imageUrl,
            level: level,
            exp: exp,
            hp: hp,
            mp: mp,
            physicalDefense: physicalDefense,
            magicDefense: magicDefense,
            requiredAccuracy: requiredAccuracy,
            bonusAccuracyPerLevelLower: bonusAccuracyPerLevelLower,
            evasionRate: evasionRate,
            mesoDropAmount: mesoDropAmount,
            mesoDropRate: mesoDropRate,
            typeEffectiveness: typeEffectiveness,
            bookmarkId: bookmarkId
        )
    }
}
