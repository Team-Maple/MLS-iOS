import DomainInterface

public final class ParseItemFilterResultUseCaseImpl: ParseItemFilterResultUseCase {

    private let jobIdMap: [String: Int] = [
        "전사": 100, "마법사": 200, "도적": 400, "궁수": 300
    ]
    private let categoryIdMap: [String: Int] = [
        "한손검": 7, "한손도끼": 8, "한손둔기": 9, "단검": 10, "완드": 12,
        "스태프": 13, "두손검": 14, "두손도끼": 15, "두손둔기": 16, "창": 17,
        "폴암": 18, "활": 19, "석궁": 20, "아대": 21, "모자": 24, "상의": 25,
        "하의": 26, "전신갑옷": 27, "신발": 28, "장갑": 29, "방패": 31, "망토": 30,
        "얼굴장식": 32, "눈장식": 33, "귀고리": 34, "반지": 35, "펜던트": 36,
        "벨트": 37, "어깨장식": 38, "화살": 81, "표창": 83,
        "한손검주문서": 50, "한손도끼주문서": 51, "한손둔기주문서": 52,
        "단검주문서": 53, "완드주문서": 55, "스태프주문서": 56, "두손검주문서": 57,
        "두손도끼주문서": 58, "두손둔기주문서": 59, "창주문서": 60, "폴암주문서": 61,
        "활주문서": 62, "석궁주문서": 63, "아대주문서": 64, "투구주문서": 67, "상의주문서": 68, "하의주문서": 69, "전신갑옷주문서": 70, "신발주문서": 71, "장갑주문서": 72, "망토주문서": 73, "방패주문서": 74,
        "귀장식주문서": 78, "펫장비주문서": 75, "연성서주문서": 76, "귀환주문서": 77,
        "마스터리북": 42, "스킬북": 43, "소비": 44, "설치": 45, "이동수단": 46
    ]

    public init() {}

    public func execute(results: [(String, String)]) -> ItemFilterCriteria {
        let initialCriteria = (jobIds: [Int](), startLevel: Int?(nil), endLevel: Int?(nil), categoryIds: [Int]())

        let finalCriteria = results.reduce(into: initialCriteria) { criteria, result in
            let (key, value) = result
            switch key {
            case "직업":
                if let id = jobIdMap[value] {
                    criteria.jobIds.append(id)
                }
            case "레벨":
                let levelText = value.replacingOccurrences(of: "레벨", with: "").trimmingCharacters(in: .whitespaces)
                let parts = levelText.split(separator: "~").map { $0.trimmingCharacters(in: .whitespaces) }
                if let low = Int(parts.first ?? ""), let high = Int(parts.last ?? "") {
                    criteria.startLevel = low
                    criteria.endLevel = high
                }
            case "무기", "발사체", "방어구", "장신구", "기타아이템":
                if let id = categoryIdMap[value] {
                    criteria.categoryIds.append(id)
                }
            case "무기주문서", "방어구주문서", "기타주문서":
                if let id = categoryIdMap[value + "주문서"] {
                    criteria.categoryIds.append(id)
                }
            default:
                break
            }
        }

        return ItemFilterCriteria(jobIds: finalCriteria.jobIds, startLevel: finalCriteria.startLevel, endLevel: finalCriteria.endLevel, categoryIds: finalCriteria.categoryIds)
    }
}
