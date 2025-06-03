import UIKit

import AuthFeature
import AuthFeatureInterface
import Core
import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

class ViewController: UIViewController {
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()

    let componentViews: [UIViewController] = [
        CheckBoxButtonTestViewController(),
        NavigationBarTestViewController(),
        CommonButtonTestViewController(),
        InputBoxTextViewController(),
        DropDownBoxTextViewController(),
        ToastMakerTestViewController(),
        ErrorMessageTextViewController()
    ]

    lazy var authViews: [UIViewController] = {
        let loginVC = DIContainer.resolve(type: LoginFactory.self).make(isReLogin: false)
        loginVC.title = "로그인"

        let termVC = DIContainer.resolve(type: TermsAgreementFactory.self).make()
        termVC.title = "약관 동의"

        let questionVC = DIContainer.resolve(type: OnBoardingFactory.self, name: "onBoardingQuestion").make()
        questionVC.title = "온보딩 진입"

        let inputVC = DIContainer.resolve(type: OnBoardingFactory.self, name: "onBoardingInput").make()
        inputVC.title = "온보딩 입력"

        let notiVC = DIContainer.resolve(type: OnBoardingFactory.self, name: "onBoardingNotification").make()
        notiVC.title = "온보딩 알림"

        return [
            loginVC,
            termVC,
            questionVC,
            inputVC,
            notiVC
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "MLS Design System"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Components"
        case 1:
            return "Auth"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return componentViews.count
        case 1:
            return authViews.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let viewController: UIViewController

        switch indexPath.section {
        case 0:
            viewController = componentViews[indexPath.row]
        case 1:
            viewController = authViews[indexPath.row]
        default:
            return cell
        }

        cell.textLabel?.text = viewController.title
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextController: UIViewController

        switch indexPath.section {
        case 0:
            nextController = componentViews[indexPath.row]
        case 1:
            nextController = authViews[indexPath.row]
        default:
            return
        }

        navigationController?.pushViewController(nextController, animated: true)
    }
}
