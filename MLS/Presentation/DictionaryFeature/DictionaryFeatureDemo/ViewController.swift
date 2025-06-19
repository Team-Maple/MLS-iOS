import UIKit

import Core
import DesignSystem
import DictionaryFeatureInterface
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

    lazy var views: [[UIViewController]] = {
        let itemFilterBottomSheetVC = DIContainer.resolve(type: ItemFilterBottomSheetFactory.self).make()
        itemFilterBottomSheetVC.title = "아이템 필터"

        let dictionaryMainVC = DIContainer.resolve(type: DictionaryMainViewFactory.self).make()
        dictionaryMainVC.title = "도감 메인"

        let modalVC = [itemFilterBottomSheetVC]
        return [
            modalVC,
            [BottomTabBarController(viewControllers: [
                UIViewController(),
                dictionaryMainVC,
                UIViewController(),
                UIViewController()
            ])]
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
        if indexPath.section == 0 {
            navigationController?.present(nextController, animated: true)
        } else if indexPath.section == 1 {
            nextController.modalPresentationStyle = .fullScreen
            navigationController?.present(nextController, animated: true)
        } else {
            navigationController?.pushViewController(nextController, animated: true)
        }
    }
}

