import UIKit

import Core
import DesignSystem
import MyPageFeatureInterface

import SnapKit

class ViewController: UIViewController {
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()

    lazy var views: [[UIViewController]] = {
        let mainView = BottomTabBarController(viewControllers: [
            DIContainer.resolve(type: MyPageMainFactory.self).make()
        ])
        let announceView = BottomTabBarController(viewControllers: [
            DIContainer.resolve(type: CustomerSupportFactory.self).make(type: .announcement)
        ])

        let eventView = BottomTabBarController(viewControllers: [
            DIContainer.resolve(type: CustomerSupportFactory.self).make(type: .event)
        ])

        let patchView = BottomTabBarController(viewControllers: [
            DIContainer.resolve(type: CustomerSupportFactory.self).make(type: .patchNote)
        ])

        let termsView = BottomTabBarController(viewControllers: [
            DIContainer.resolve(type: CustomerSupportFactory.self).make(type: .terms)
        ])

        let notiView = BottomTabBarController(viewControllers: [
            DIContainer.resolve(type: NotificationSettingFactory.self).make()
        ])

        mainView.title = "마이페이지 메인"
        announceView.title = "공지사항"
        eventView.title = "이벤트"
        patchView.title = "패치 노트"
        termsView.title = "약관"
        notiView.title = "알림설정"

        return [
            [mainView, announceView, eventView, patchView, termsView, notiView]
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return views.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return views[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = views[indexPath.section][indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextController = views[indexPath.section][indexPath.row]
        navigationController?.pushViewController(nextController, animated: true)
    }
}
