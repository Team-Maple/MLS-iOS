import UIKit

import AuthFeature
import AuthFeatureInterface
import Core
import Domain
import DomainInterface

import RxCocoa
import RxSwift
import SnapKit

class ViewController: UIViewController {
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()

    lazy var views: [UIViewController] = {
        let loginVC = DIContainer.resolve(type: LoginFactory.self).make(isReLogin: false)
        loginVC.title = "로그인"

        struct Credential: Encodable {
            var some: String
        }
        let termVC = DIContainer.resolve(type: TermsAgreementFactory.self).make(credential: Credential(some: "some"))
        termVC.title = "약관 동의"

        let questionVC = DIContainer.resolve(type: OnBoardingQuestionFactory.self).make()
        questionVC.title = "온보딩 진입"

        let inputVC = DIContainer.resolve(type: OnBoardingInputFactory.self).make()
        inputVC.title = "온보딩 입력"

        let notiVC = DIContainer.resolve(type: OnBoardingNotificationFactory.self).make()
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
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "MLS Feature System"

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return views.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = views[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextController = views[indexPath.row]
        navigationController?.pushViewController(nextController, animated: true)
    }
}
