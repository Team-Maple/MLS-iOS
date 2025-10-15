import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public final class CustomerSupportBaseViewFactoryImpl: CustomerSupportFactory {
    public init() {

    }

    public func make(type: CustomerSupportType) -> BaseViewController {
        var viewController = BaseViewController()

        switch type {
        case .event:
            viewController = EventViewController(type: .event)
            if let viewController = viewController as? EventViewController {

            }
        case .announcement:
            viewController = AnnouncementViewController(type: .announcement)
            if let viewController = viewController as? AnnouncementViewController {

            }
        case .patchNote:
            viewController = PatchNoteViewController(type: .patchNote)
            if let viewController = viewController as? PatchNoteViewController {

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
