import MLSCore
import MLSMyPageFeatureInterface

public final class CustomerSupportBaseViewFactoryImpl: CustomerSupportFactory {
    private let policyFactory: PolicyFactory

    private let alarmRepository: AlarmRepository

    public init(
        policyFactory: PolicyFactory,
        alarmRepository: AlarmRepository
    ) {
        self.policyFactory = policyFactory
        self.alarmRepository = alarmRepository
    }

    public func make(type: CustomerSupportType) -> BaseViewController {
        var viewController = BaseViewController()

        switch type {
        case .event:
            viewController = EventViewController(type: .event)
            if let viewController = viewController as? EventViewController {
                viewController.reactor = EventReactor(alarmRepository: alarmRepository)
            }
        case .announcement:
            viewController = AnnouncementViewController(type: .announcement)
            if let viewController = viewController as? AnnouncementViewController {
                viewController.reactor = AnnouncementReactor(alarmRepository: alarmRepository)
            }
        case .patchNote:
            viewController = PatchNoteViewController(type: .patchNote)
            if let viewController = viewController as? PatchNoteViewController {
                viewController.reactor = PatchNoteReactor(alarmRepository: alarmRepository)
            }
        case .terms:
            viewController  = TermsViewController(type: .terms, policyFactory: policyFactory)
        }

        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
