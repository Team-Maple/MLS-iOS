import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public final class CustomerSupportBaseViewFactoryImpl: CustomerSupportFactory {
    private let policyFactory: PolicyFactory

    private let fetchNoticesUseCase: FetchNoticesUseCase
    private let fetchOngoingEventsUseCase: FetchOngoingEventsUseCase
    private let fetchOutdatedEventsUseCase: FetchOutdatedEventsUseCase
    private let fetchPatchNotesUseCase: FetchPatchNotesUseCase
    private let setReadUseCase: SetReadUseCase

    public init(
        policyFactory: PolicyFactory,
        fetchNoticesUseCase: FetchNoticesUseCase,
        fetchOngoingEventsUseCase: FetchOngoingEventsUseCase,
        fetchOutdatedEventsUseCase: FetchOutdatedEventsUseCase,
        fetchPatchNotesUseCase: FetchPatchNotesUseCase,
        setReadUseCase: SetReadUseCase
    ) {
        self.policyFactory = policyFactory
        self.fetchNoticesUseCase = fetchNoticesUseCase
        self.fetchOngoingEventsUseCase = fetchOngoingEventsUseCase
        self.fetchOutdatedEventsUseCase = fetchOutdatedEventsUseCase
        self.fetchPatchNotesUseCase = fetchPatchNotesUseCase
        self.setReadUseCase = setReadUseCase
    }

    public func make(type: CustomerSupportType) -> BaseViewController {
        var viewController = BaseViewController()

        switch type {
        case .event:
            viewController = EventViewController(type: .event)
            if let viewController = viewController as? EventViewController {
                viewController.reactor = EventReactor(fetchOngoingEventsUseCase: fetchOngoingEventsUseCase, fetchOutdatedEventsUseCase: fetchOutdatedEventsUseCase, setReadUseCase: setReadUseCase)
            }
        case .announcement:
            viewController = AnnouncementViewController(type: .announcement)
            if let viewController = viewController as? AnnouncementViewController {
                viewController.reactor = AnnouncementReactor(fetchNoticesUseCase: fetchNoticesUseCase, setReadUseCase: setReadUseCase)
            }
        case .patchNote:
            viewController = PatchNoteViewController(type: .patchNote)
            if let viewController = viewController as? PatchNoteViewController {
                viewController.reactor = PatchNoteReactor(fetchPatchNotesUseCase: fetchPatchNotesUseCase, setReadUseCase: setReadUseCase)
            }
        case .terms:
            viewController  = TermsViewController(type: .terms, policyFactory: policyFactory)
        }

        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
