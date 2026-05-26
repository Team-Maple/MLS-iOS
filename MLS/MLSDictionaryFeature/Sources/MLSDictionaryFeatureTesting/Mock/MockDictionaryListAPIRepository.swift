import MLSDictionaryFeatureInterface

import RxSwift

public final class MockDictionaryListAPIRepository:
    DictionaryListAPIRepository {

    public init() {}

    // MARK: - Search Count

    public func fetchSearchListCount(
        type: String,
        keyword: String?
    ) -> Observable<SearchCountResponse> {

        .just(
            SearchCountResponse(count: 99)
        )
    }

    // MARK: - Search List

    public func fetchSearchList(
        keyword: String?
    ) -> Observable<DictionaryMainResponse> {

        .just(makeAllResponse())
    }

    // MARK: - All List

    public func fetchAllList(
        keyword: String?,
        page: Int?
    ) -> Observable<DictionaryMainResponse> {

        .just(makeAllResponse())
    }

    // MARK: - Monster List

    public func fetchMonsterList(
        keyword: String?,
        minLevel: Int?,
        maxLevel: Int?,
        page: Int,
        size: Int,
        sort: String?
    ) -> Observable<DictionaryMainResponse> {

        .just(
            DictionaryMainResponse(
                totalPages: 1,
                totalElements: 1,
                contents: [
                    DictionaryMainItemResponse(
                        id: 1,
                        name: "슬라임",
                        imageUrl: nil,
                        level: 1,
                        type: .monster,
                        bookmarkId: nil
                    )
                ]
            )
        )
    }

    // MARK: - NPC List

    public func fetchNpcList(
        keyword: String,
        page: Int,
        size: Int,
        sort: String?
    ) -> Observable<DictionaryMainResponse> {

        .just(
            DictionaryMainResponse(
                totalPages: 1,
                totalElements: 1,
                contents: [
                    DictionaryMainItemResponse(
                        id: 2,
                        name: "루크",
                        imageUrl: nil,
                        level: nil,
                        type: .npc,
                        bookmarkId: nil
                    )
                ]
            )
        )
    }

    // MARK: - Quest List

    public func fetchQuestList(
        keyword: String,
        page: Int,
        size: Int,
        sort: String?
    ) -> Observable<DictionaryMainResponse> {

        .just(
            DictionaryMainResponse(
                totalPages: 1,
                totalElements: 1,
                contents: [
                    DictionaryMainItemResponse(
                        id: 3,
                        name: "슬라임 퇴치",
                        imageUrl: nil,
                        level: 10,
                        type: .quest,
                        bookmarkId: nil
                    )
                ]
            )
        )
    }

    // MARK: - Item List

    public func fetchItemList(
        keyword: String?,
        jobId: [Int]?,
        minLevel: Int?,
        maxLevel: Int?,
        categoryIds: [Int]?,
        page: Int?,
        size: Int?,
        sort: String?
    ) -> Observable<DictionaryMainResponse> {

        .just(
            DictionaryMainResponse(
                totalPages: 1,
                totalElements: 1,
                contents: [
                    DictionaryMainItemResponse(
                        id: 4,
                        name: "빨간 포션",
                        imageUrl: nil,
                        level: 1,
                        type: .item,
                        bookmarkId: nil
                    )
                ]
            )
        )
    }

    // MARK: - Map List

    public func fetchMapList(
        keyword: String,
        page: Int,
        size: Int,
        sort: String?
    ) -> Observable<DictionaryMainResponse> {

        .just(
            DictionaryMainResponse(
                totalPages: 1,
                totalElements: 1,
                contents: [
                    DictionaryMainItemResponse(
                        id: 5,
                        name: "헤네시스",
                        imageUrl: nil,
                        level: nil,
                        type: .map,
                        bookmarkId: nil
                    )
                ]
            )
        )
    }
}

// MARK: - Private

private extension MockDictionaryListAPIRepository {

    func makeAllResponse() -> DictionaryMainResponse {
        DictionaryMainResponse(
            totalPages: 1,
            totalElements: 5,
            contents: [
                DictionaryMainItemResponse(
                    id: 1,
                    name: "슬라임",
                    imageUrl: nil,
                    level: 1,
                    type: .monster,
                    bookmarkId: nil
                ),
                DictionaryMainItemResponse(
                    id: 2,
                    name: "빨간 포션",
                    imageUrl: nil,
                    level: 1,
                    type: .item,
                    bookmarkId: nil
                ),
                DictionaryMainItemResponse(
                    id: 3,
                    name: "헤네시스",
                    imageUrl: nil,
                    level: nil,
                    type: .map,
                    bookmarkId: nil
                ),
                DictionaryMainItemResponse(
                    id: 4,
                    name: "루크",
                    imageUrl: nil,
                    level: nil,
                    type: .npc,
                    bookmarkId: nil
                ),
                DictionaryMainItemResponse(
                    id: 5,
                    name: "슬라임 퇴치",
                    imageUrl: nil,
                    level: 10,
                    type: .quest,
                    bookmarkId: nil
                )
            ]
        )
    }
}
