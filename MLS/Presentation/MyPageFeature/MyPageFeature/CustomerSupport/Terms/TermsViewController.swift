import UIKit

final class TermsViewController: CustomerSupportBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let items = [
            "서비스 이용약관",
            "개인정보 처리방침",
            "마케팅 정보 수신 동의",
            "오픈소스 라이선스 보기"
        ]

        mainView.setMenuHidden(true)
        mainView.changeeSetupConstraints()
        createTermsDetailItem(items: items)
    }
}
