import UIKit

final class PatchNoteViewController: CustomerSupportBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let items = [
            ("2025년 7월 25일(금) 패치노트1", "2025년 07월 25일(금) 12:55"),
            ("2025년 7월 25일(금) 패치노트2", "2025년 07월 25일(금) 12:55"),
            ("2025년 7월 25일(금) 패치노트3", "2025년 07월 25일(금) 12:55")
        ]

        mainView.setMenuHidden(true)
        mainView.changeeSetupConstraints()
        createDetailItem(items: items)
    }
}
