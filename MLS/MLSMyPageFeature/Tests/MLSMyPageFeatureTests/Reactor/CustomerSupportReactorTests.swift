@testable import MLSMyPageFeature

import Testing

import MLSMyPageFeatureInterface
import MLSMyPageFeatureTesting

import ReactorKit
import RxBlocking
import RxSwift

@Suite("CustomerSupportReactorTests")
struct CustomerSupportReactorTests {

    // MARK: - 이벤트 페이지
    @Test("첫번째 탭 선택하면 ongoing 이벤트 fetch")
    func selectTab_ongoing_emitsMutations() throws {
        let repo = MockAlarmRepository()
        let reactor = EventReactor(alarmRepository: repo)

        let mutations = try reactor
            .mutate(action: .selectTab(0))
            .toBlocking()
            .toArray()

        switch mutations[0] {
        case .setIndex(let index):
            #expect(index == 0)
        default:
            #expect(Bool(false), "Expected setIndex")
        }
    }

    @Test("두번째 탭 선택하면 outdated 이벤트 fetch")
    func selectTab_outdated_emitsMutations() throws {
        let repo = MockAlarmRepository()
        let reactor = EventReactor(alarmRepository: repo)

        let mutations = try reactor
            .mutate(action: .selectTab(1))
            .toBlocking()
            .toArray()

        switch mutations[0] {
        case .setIndex(let index):
            #expect(index == 1)
        default:
            #expect(Bool(false), "Expected setIndex")
        }
    }

    // MARK: - 공통
    @Test("reset = true로 업데이트면 alarm 교체")
    func setAlarms_replacesItems() {
        let reactor = EventReactor(alarmRepository: MockAlarmRepository())

        let alarms = [
            AlarmResponse(
                id: 1,
                type: "notice",
                title: "공지",
                link: "https://example.com/1",
                date: "2026-04-26"
            )
        ]

        let state = reactor.reduce(
            state: reactor.initialState,
            mutation: .setAlarms(alarms, hasMore: true, reset: true)
        )

        #expect(state.alarms.count == 1)
        #expect(state.hasMore == true)
    }

    @Test("reset = false로 업데이트면 alarm 추가")
    func setAlarms_addsItems() {
        let reactor = EventReactor(alarmRepository: MockAlarmRepository())

        let base = EventReactor.State(
            alarms: [
                AlarmResponse(
                    id: 1,
                    type: "notice",
                    title: "기존",
                    link: "https://example.com/1",
                    date: "2026-04-26"
                )
            ],
            selectedIndex: 0,
            hasMore: true,
            isLoading: false
        )

        let newItems = [
            AlarmResponse(
                id: 2,
                type: "notice",
                title: "추가",
                link: "https://example.com/2",
                date: "2026-04-26"
            )
        ]

        let state = reactor.reduce(
            state: base,
            mutation: .setAlarms(newItems, hasMore: false, reset: false)
        )

        #expect(state.alarms.count == 2)
        #expect(state.hasMore == false)
    }
}
