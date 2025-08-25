import UIKit

import BaseFeature
import BookmarkFeatureInterface
import Core
import DesignSystem
import DictionaryFeatureInterface

import SnapKit

class ViewController: UIViewController {
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()

    lazy var views: [[UIViewController]] = {
        let dictionaryMainVC = DIContainer.resolve(type: DictionaryMainViewFactory.self).make()

        let bookmarkMainVC = DIContainer.resolve(type: BookmarkMainFactory.self).make()

        let dictView = BottomTabBarController(viewControllers: [
            dictionaryMainVC,
            bookmarkMainVC,
            BaseViewController()
        ])
        dictView.title = "도감 메인"

        return [
            [dictView]
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
