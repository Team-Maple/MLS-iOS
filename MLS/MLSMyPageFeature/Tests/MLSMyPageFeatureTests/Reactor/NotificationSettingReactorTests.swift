@testable import MLSMyPageFeature

import Testing

import MLSAuthFeatureInterface
import MLSAuthFeatureTesting
import MLSMyPageFeatureInterface
import MLSMyPageFeatureTesting

import ReactorKit
import RxBlocking
import RxSwift

@Suite("NotificationSettingReactorTests")
struct NotificationSettingReactorTests {
    @Test("viewWillAppear에서 authorization 불러오기")
    func viewWillAppear_setsAuthorized() throws {
        let reactor = makeSUT(authorized: true)

        let mutation = try reactor
            .mutate(action: .viewWillAppear)
            .toBlocking()
            .first()!

        switch mutation {
        case .setAuthorized(let value):
            #expect(value == true)
        default:
            #expect(Bool(false), "Expected setAuthorized")
        }
    }

    @Test("appWillEnterForeground에서 authorization 불러오기")
    func appWillEnterForeground_setsAuthorized() throws {
        let reactor = makeSUT(authorized: false)

        let mutation = try reactor
            .mutate(action: .appWillEnterForeground)
            .toBlocking()
            .first()!

        switch mutation {
        case .setAuthorized(let value):
            #expect(value == false)
        default:
            #expect(Bool(false), "Expected setAuthorized")
        }
    }

    @Test("backButton 클릭하면 dismiss")
    func backButtonTapped_routesDismiss() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .backButtonTapped)
            .toBlocking()
            .first()!

        switch mutation {
        case .toNavigate(let route):
            #expect(route == .dismiss)
        default:
            #expect(Bool(false), "Expected toNavigate")
        }
    }

    @Test("pushGuideView 클릭하면 setting")
    func pushGuideViewTapped_routesSetting() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .pushGuideViewTapped)
            .toBlocking()
            .first()!

        switch mutation {
        case .toNavigate(let route):
            #expect(route == .setting)
        default:
            #expect(Bool(false), "Expected toNavigate")
        }
    }

    @Test("Authorization을 true로 수정하면 setAuthorized")
    func updateAuthorization_setsAuthorized() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .updateAuthorization(true))
            .toBlocking()
            .first()!

        switch mutation {
        case .setAuthorized(let value):
            #expect(value == true)
        default:
            #expect(Bool(false), "Expected setAuthorized")
        }
    }

    @Test("eventViewSwitch 변경하면 eventNotification 허용")
    func eventViewSwitch_updatesState() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .eventViewSwitch(true))
            .toBlocking()
            .first()!

        switch mutation {
        case .setEventNotification(let value):
            #expect(value == true)
        default:
            #expect(Bool(false), "Expected setEventNotification")
        }
    }

    @Test("noticeViewSwitch 변경하면 -> noticeNotification 허용")
    func noticeViewSwitch_updatesState() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .noticeViewSwitch(true))
            .toBlocking()
            .first()!

        switch mutation {
        case .setNoticeNotification(let value):
            #expect(value == true)
        default:
            #expect(Bool(false), "Expected setNoticeNotification")
        }
    }

    @Test("patchNoteViewSwitch 변경하면 patchNoteNotification 허용")
    func patchNoteViewSwitch_updatesState() throws {
        let reactor = makeSUT()

        let mutation = try reactor
            .mutate(action: .patchNoteViewSwitch(true))
            .toBlocking()
            .first()!

        switch mutation {
        case .setPatchNoteNotification(let value):
            #expect(value == true)
        default:
            #expect(Bool(false), "Expected setPatchNoteNotification")
        }
    }
}

extension NotificationSettingReactorTests {
    private func makeSUT(
        authorized: Bool = false,
        event: Bool = false,
        notice: Bool = false,
        patch: Bool = false
    ) -> NotificationSettingReactor {
        let notificationRepo = MockNotificationPermissionRepository()
        notificationRepo.fetchAuthorizationStatusResult = authorized

        let authRepo = MockAuthAPIRepository()

        return NotificationSettingReactor(
            notificationRepository: notificationRepo,
            authRepository: authRepo,
            isAgreeEventNotification: event,
            isAgreeNoticeNotification: notice,
            isAgreePatchNoteNotification: patch
        )
    }
}
