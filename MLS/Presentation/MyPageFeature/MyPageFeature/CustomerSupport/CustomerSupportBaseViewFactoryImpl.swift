import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public final class CustomerSupportBaseViewFactoryImpl: CustomerSupportFactory {
    private let fetchNoticesUseCase: FetchNoticesUseCase
    private let fetchOngoingEventsUseCase: FetchOngoingEventsUseCase
    private let fetchOutdatedEventsUseCase: FetchOutdatedEventsUseCase
    private let fetchPatchNotesUseCase: FetchPatchNotesUseCase
    
    public init(fetchNoticesUseCase: FetchNoticesUseCase, fetchOngoingEventsUseCase: FetchOngoingEventsUseCase, fetchOutdatedEventsUseCase: FetchOutdatedEventsUseCase, fetchPatchNotesUseCase: FetchPatchNotesUseCase) {
        self.fetchNoticesUseCase = fetchNoticesUseCase
        self.fetchOngoingEventsUseCase = fetchOngoingEventsUseCase
        self.fetchOutdatedEventsUseCase = fetchOutdatedEventsUseCase
        self.fetchPatchNotesUseCase = fetchPatchNotesUseCase
    }

    public func make(type: CustomerSupportType) -> BaseViewController {
        var viewController = BaseViewController()

        switch type {
        case .event:
            viewController = EventViewController(type: .event)
            if let viewController = viewController as? EventViewController {
                viewController.reactor = EventReactor(fetchOngoingEventsUseCase: fetchOngoingEventsUseCase, fetchOutdatedEventsUseCase: fetchOutdatedEventsUseCase)
            }
        case .announcement:
            viewController = AnnouncementViewController(type: .announcement)
            if let viewController = viewController as? AnnouncementViewController {
                viewController.reactor = AnnouncementReactor(fetchNoticesUseCase: fetchNoticesUseCase)
            }
        case .patchNote:
            viewController = PatchNoteViewController(type: .patchNote)
            if let viewController = viewController as? PatchNoteViewController {
                viewController.reactor = PatchNoteReactor(fetchPatchNotesUseCase: fetchPatchNotesUseCase)
            }
        case .terms:
            viewController  = TermsViewController(type: .terms)
            if let viewController = viewController as? TermsViewController {

            }
        }

        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
