import UIKit

final class AnnouncementViewController: CustomerSupportBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let items = [
            ("2025년 7월 25일(금) 공지사항1", "2025년 07월 25일(금) 12:55"),
            ("2025년 7월 25일(금) 공지사항2", "2025년 07월 25일(금) 12:55"),
            ("2025년 7월 25일(금) 공지사항3", "2025년 07월 25일(금) 12:55")
        ]

        // 타입을 나눠서 베이스에서 다 처리하는게 나을려나??
        mainView.menuStackView.isHidden = true
        changeeSetupConstraints()
        createDetailItem(items: items)
    }
}
