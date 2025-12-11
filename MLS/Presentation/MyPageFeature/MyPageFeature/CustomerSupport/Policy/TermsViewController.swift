import UIKit

import MyPageFeatureInterface

final class TermsViewController: CustomerSupportBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let items = PolicyType.allCases

        mainView.setMenuHidden(true)
        mainView.changeSetupConstraints()
        createTermsDetailItem(items: items.map { $0.title })
    }
}
