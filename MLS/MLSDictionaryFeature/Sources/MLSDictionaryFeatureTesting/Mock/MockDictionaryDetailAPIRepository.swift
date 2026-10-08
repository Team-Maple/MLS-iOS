import MLSDictionaryFeatureInterface

import RxSwift

public final class MockDictionaryDetailAPIRepository:
    DictionaryDetailAPIRepository {

    public init() {}

    // MARK: - Monster

    public func fetchMonsterDetail(
        id: Int
    ) -> Observable<DictionaryDetailMonsterResponse> {

        .just(
            DictionaryDetailMonsterResponse(
                monsterId: id,
                nameKr: "슬라임",
                nameEn: "Slime",
                imageUrl: "",
                level: 1,
                exp: 5,
                hp: 50,
                mp: 10,
                physicalDefense: 3,
                magicDefense: 2,
                requiredAccuracy: 1,
                bonusAccuracyPerLevelLower: 0,
                evasionRate: 1,
                mesoDropAmount: 12,
                mesoDropRate: 100,
                typeEffectiveness: Effectiveness(
                    fire: "WEAK",
                    lightning: nil,
                    poison: nil,
                    holy: nil,
                    ice: "RESIST",
                    physical: nil
                ),
                bookmarkId: nil
            )
        )
    }

    public func fetchMonsterDetailDropItem(
        id: Int,
        sort: String?
    ) -> Observable<[DictionaryDetailMonsterDropItemResponse]> {

        .just([
            DictionaryDetailMonsterDropItemResponse(
                itemId: 1,
                itemName: "빨간 포션",
                dropRate: 0.5,
                imageUrl: "",
                itemLevel: 1
            )
        ])
    }

    public func fetchMonsterDetailMap(
        id: Int
    ) -> Observable<[DictionaryDetailMonsterMapResponse]> {

        .just([
            DictionaryDetailMonsterMapResponse(
                mapId: 1,
                mapName: "헤네시스 사냥터",
                regionName: "빅토리아 아일랜드",
                detailName: "동쪽 풀숲",
                topRegionName: "헤네시스",
                iconUrl: "",
                maxSpawnCount: 10
            )
        ])
    }

    // MARK: - NPC

    public func fetchNpcDetail(
        id: Int
    ) -> Observable<DictionaryDetailNpcResponse> {

        .just(
            DictionaryDetailNpcResponse(
                npcId: id,
                nameKr: "루크",
                nameEn: "Luke",
                iconUrlDetail: nil,
                bookmarkId: nil
            )
        )
    }

    public func fetchNpcDetailQuest(
        id: Int,
        sort: String?
    ) -> Observable<[DictionaryDetailNpcQuestResponse]> {

        .just([
            DictionaryDetailNpcQuestResponse(
                questId: 1,
                questNameKr: "슬라임 퇴치",
                questNameEn: "Slime Hunt",
                questIconUrl: "",
                minLevel: 1,
                maxLevel: 10
            )
        ])
    }

    public func fetchNpcDetailMap(
        id: Int
    ) -> Observable<[DictionaryDetailMonsterMapResponse]> {

        .just([
            DictionaryDetailMonsterMapResponse(
                mapId: 1,
                mapName: "헤네시스",
                regionName: "빅토리아 아일랜드",
                detailName: "마을",
                topRegionName: "헤네시스",
                iconUrl: "",
                maxSpawnCount: nil
            )
        ])
    }

    // MARK: - Item

    public func fetchItemDetail(
        id: Int
    ) -> Observable<DictionaryDetailItemResponse> {

        .just(
            DictionaryDetailItemResponse(
                itemId: id,
                nameKr: "빨간 포션",
                nameEn: "Red Potion",
                descriptionText: "HP를 회복한다.",
                imgUrl: "",
                npcPrice: 50,
                itemType: "consumable",
                categoryHierarchy: nil,
                availableJobs: nil,
                requiredStats: nil,
                equipmentStats: nil,
                scrollDetail: nil,
                bookmarkId: nil
            )
        )
    }

    public func fetchItemDetailDropMonster(
        id: Int,
        sort: String?
    ) -> Observable<[DictionaryDetailItemDropMonsterResponse]> {

        .just([
            DictionaryDetailItemDropMonsterResponse(
                monsterId: 1,
                monsterName: "슬라임",
                level: 1,
                dropRate: 0.5,
                imageUrl: ""
            )
        ])
    }

    // MARK: - Quest

    public func fetchQuestDetail(
        id: Int
    ) -> Observable<DictionaryDetailQuestResponse> {

        .just(
            DictionaryDetailQuestResponse(
                questId: id,
                titlePrefix: "[초보자]",
                nameKr: "슬라임 퇴치",
                nameEn: "Slime Hunt",
                iconUrl: "",
                questType: "NORMAL",
                minLevel: 1,
                maxLevel: 10,
                requiredMesoStart: nil,
                startNpcId: 1,
                startNpcName: "루크",
                endNpcId: 1,
                endNpcName: "루크",
                reward: MLSDictionaryFeatureInterface.Reward(exp: 100, meso: 50, popularity: nil),
                rewardItems: [],
                requirements: [],
                allowedJobs: [],
                bookmarkId: nil
            )
        )
    }

    public func fetchQuestDetailLinkedQuestsDetail(
        id: Int
    ) -> Observable<DictionaryDetailQuestLinkedQuestsResponse> {

        .just(
            DictionaryDetailQuestLinkedQuestsResponse(
                previousQuests: [],
                nextQuests: []
            )
        )
    }

    // MARK: - Map

    public func fetchMapDetail(
        id: Int
    ) -> Observable<DictionaryDetailMapResponse> {

        .just(
            DictionaryDetailMapResponse(
                mapId: id,
                nameKr: "헤네시스",
                nameEn: "Henesys",
                regionName: "빅토리아 아일랜드",
                detailName: "마을",
                topRegionName: "헤네시스",
                mapUrl: "",
                iconUrl: "",
                bookmarkId: nil
            )
        )
    }

    public func fetchMapDetailSpawnMonster(
        id: Int,
        sort: String?
    ) -> Observable<[DictionaryDetailMapSpawnMonsterResponse]> {

        .just([
            DictionaryDetailMapSpawnMonsterResponse(
                monsterId: 1,
                monsterName: "슬라임",
                level: 1,
                maxSpawnCount: 10,
                imageUrl: ""
            )
        ])
    }

    public func fetchMapDetailNpc(
        id: Int
    ) -> Observable<[DictionaryDetailMapNpcResponse]> {

        .just([
            DictionaryDetailMapNpcResponse(
                npcId: 1,
                npcName: "루크",
                npcNameEn: "Luke",
                iconUrl: ""
            )
        ])
    }
}
