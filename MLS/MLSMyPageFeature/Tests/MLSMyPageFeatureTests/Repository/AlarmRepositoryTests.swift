@testable import MLSMyPageFeature

import Testing

import MLSCore
import MLSMyPageFeatureInterface
import MLSMyPageFeatureTesting

import RxBlocking
import RxSwift

@Suite("AlarmAPIRepositoryImplTests")
struct AlarmAPIRepositoryImplTests {
    private let normalDTO = AlarmResponseDTO(
        contents: [
            .normal(
                .init(
                    id: 1,
                    type: "notice",
                    title: "공지사항",
                    link: "https://example.com/1",
                    date: "2026-04-01"
                )
            ),
            .normal(
                .init(
                    id: 2,
                    type: "patch",
                    title: "패치노트",
                    link: "https://example.com/2",
                    date: "2026-04-02"
                )
            ),
        ],
        hasMore: true
    )

    private let allDTO = AlarmResponseDTO(
        contents: [
            .all(
                .init(
                    alrim: .init(
                        id: 1,
                        type: "notice",
                        title: "공지사항",
                        link: "https://example.com/1",
                        date: "2026-04-01"
                    ),
                    alreadyRead: true
                )
            ),
            .all(
                .init(
                    alrim: .init(
                        id: 2,
                        type: "event",
                        title: "이벤트",
                        link: "https://example.com/2",
                        date: "2026-04-02"
                    ),
                    alreadyRead: false
                )
            ),
        ],
        hasMore: false
    )

    @Test("ongoingEvents 가져오기위해 provider 호출 및 domain 반환")
    func fetchOngoingEvents_returnsPagedEntity() throws {
        let provider = MockNetworkProvider()
        provider.responseResult = normalDTO

        let sut = makeSUT(provider: provider)

        let result =
            try sut
                .fetchOngoingEvents(cursor: nil, pageSize: 20)
                .toBlocking()
                .first()

        #expect(provider.requestWithResponseCalled)
        #expect(result?.items.count == 2)
        #expect(result?.hasMore == true)
        #expect(result?.items.first?.title == "공지사항")
    }

    @Test("outdatedEvents 가져오기위해 provider 호출")
    func fetchOutdatedEvents_returnsPagedEntity() throws {
        let provider = MockNetworkProvider()
        provider.responseResult = normalDTO

        let sut = makeSUT(provider: provider)

        let result =
            try sut
                .fetchOutdatedEvents(cursor: 10, pageSize: 20)
                .toBlocking()
                .first()

        #expect(provider.requestWithResponseCalled)
        #expect(result?.items.count == 2)
    }

    @Test("notices 가져오기위해 provider 호출")
    func fetchNotices_returnsPagedEntity() throws {
        let provider = MockNetworkProvider()
        provider.responseResult = normalDTO

        let sut = makeSUT(provider: provider)

        let result =
            try sut
                .fetchNotices(cursor: nil, pageSize: 20)
                .toBlocking()
                .first()

        #expect(provider.requestWithResponseCalled)
        #expect(result?.items.first?.type == "notice")
    }

    @Test("patchNotes 가져오기위해 provider 호출")
    func fetchPatchNotes_returnsPagedEntity() throws {
        let provider = MockNetworkProvider()
        provider.responseResult = normalDTO

        let sut = makeSUT(provider: provider)

        let result =
            try sut
                .fetchPatchNotes(cursor: nil, pageSize: 20)
                .toBlocking()
                .first()

        #expect(provider.requestWithResponseCalled)
        #expect(result?.items.last?.type == "patch")
    }

    // MARK: - fetchAll

    @Test("모든 Alarm 가져오면 domain 반환")
    func fetchAll_returnsPagedAllAlarmEntity() throws {
        let provider = MockNetworkProvider()
        provider.responseResult = allDTO

        let sut = makeSUT(provider: provider)

        let result =
            try sut
                .fetchAll(cursor: nil, pageSize: 20)
                .toBlocking()
                .first()

        #expect(provider.requestWithResponseCalled)
        #expect(result?.items.count == 2)
        #expect(result?.hasMore == false)
        #expect(result?.items.first?.alreadyRead == true)
    }

    // MARK: - setRead

    @Test("알람을 읽으면 setRead 호출 후 complete")
    func setRead_returnsComplete() throws {
        let provider = MockNetworkProvider()
        provider.completableResult = .empty()

        let sut = makeSUT(provider: provider)

        _ =
            try sut
                .setRead(alarmLink: "https://example.com/1")
                .toBlocking()
                .first()

        #expect(provider.requestCompletableCalled)
    }

    @Test("setRead에 실패하면 error 방출")
    func setRead_throwsError() {
        let provider = MockNetworkProvider()
        provider.completableResult = .error(NetworkError.httpError)

        let sut = makeSUT(provider: provider)

        #expect(throws: Error.self) {
            _ =
                try sut
                    .setRead(alarmLink: "https://example.com/1")
                    .toBlocking()
                    .first()
        }

        #expect(provider.requestCompletableCalled)
    }
}

private extension AlarmAPIRepositoryImplTests {
    func makeSUT(
        provider: MockNetworkProvider = MockNetworkProvider(),
        interceptor: MockInterceptor = MockInterceptor()
    ) -> AlarmAPIRepositoryImpl {
        AlarmAPIRepositoryImpl(
            provider: provider,
            interceptor: interceptor
        )
    }
}
