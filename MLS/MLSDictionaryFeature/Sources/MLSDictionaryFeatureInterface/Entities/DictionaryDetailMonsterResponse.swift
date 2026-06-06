import Foundation
import UIKit

public struct DictionaryDetailMonsterResponse: Equatable {

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
    public var bookmarkId: Int?

    public init(
        monsterId: Int,
        nameKr: String,
        nameEn: String,
        imageUrl: String,
        level: Int,
        exp: Int,
        hp: Int,
        mp: Int,
        physicalDefense: Int,
        magicDefense: Int,
        requiredAccuracy: Int,
        bonusAccuracyPerLevelLower: Double,
        evasionRate: Int,
        mesoDropAmount: Int?,
        mesoDropRate: Int?,
        typeEffectiveness: Effectiveness?,
        bookmarkId: Int?
    ) {
        self.monsterId = monsterId
        self.nameKr = nameKr
        self.nameEn = nameEn
        self.imageUrl = imageUrl
        self.level = level
        self.exp = exp
        self.hp = hp
        self.mp = mp
        self.physicalDefense = physicalDefense
        self.magicDefense = magicDefense
        self.requiredAccuracy = requiredAccuracy
        self.bonusAccuracyPerLevelLower = bonusAccuracyPerLevelLower
        self.evasionRate = evasionRate
        self.mesoDropAmount = mesoDropAmount
        self.mesoDropRate = mesoDropRate
        self.typeEffectiveness = typeEffectiveness
        self.bookmarkId = bookmarkId
    }
}

public struct Effectiveness: Decodable, Equatable {
    public let fire: String?
    public let lightning: String?
    public let poison: String?
    public let holy: String?
    public let ice: String?
    public let physical: String?

    public init(fire: String?, lightning: String?, poison: String?, holy: String?, ice: String?, physical: String?) {
        self.fire = fire
        self.lightning = lightning
        self.poison = poison
        self.holy = holy
        self.ice = ice
        self.physical = physical
    }
    // 순회하기 위해서
    public func nonNilElements() -> [(element: ElementType, value: String)] {
        var result: [(ElementType, String)] = []

        if let fire = fire { result.append((.fire, toKoreanEffect(data: fire))) }
        if let lightning = lightning { result.append((.lightning, toKoreanEffect(data: lightning))) }
        if let poison = poison { result.append((.poison, toKoreanEffect(data: poison))) }
        if let holy = holy { result.append((.holy, toKoreanEffect(data: holy))) }
        if let ice = ice { result.append((.ice, toKoreanEffect(data: ice))) }
        if let physical = physical { result.append((.physical, toKoreanEffect(data: physical))) }

        return result
    }
    // 몬스터 약점 태그를 위한 변환
    private func toKoreanEffect(data: String) -> String {
        switch data {
        case "RESIST": return "저항"
        case "WEAK": return "약점"
        case "IMMUNE": return "면역"
        default:
            return ""
        }
    }
}

public enum ElementType: String {
    case fire = "불"
    case lightning = "번개"
    case poison = "독"
    case holy = "빛"
    case ice = "얼음"
    case physical = "물리"
}
