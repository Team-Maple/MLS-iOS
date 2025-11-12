import UIKit

import BaseFeature
import BookmarkFeatureInterface
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
        let itemFilterBottomSheetVC = DIContainer.resolve(type: ItemFilterBottomSheetFactory.self).make { _ in }
        itemFilterBottomSheetVC.title = "아이템 필터 바텀시트"

        let monsterBottomSheetVC = DIContainer.resolve(type: MonsterFilterBottomSheetFactory.self).make(startLevel: 0, endLevel: 200) { _, _ in }
        monsterBottomSheetVC.title = "몬스터 필터 바텀시트"

        let sortedBottomSheetVC = DIContainer.resolve(type: SortedBottomSheetFactory.self).make(sortedOptions: [
            .korean
        ], selectedIndex: 0, onSelectedIndex: {_ in })
        sortedBottomSheetVC.title = "정렬 바텀시트"

        let modalVC = [itemFilterBottomSheetVC, monsterBottomSheetVC, sortedBottomSheetVC]

        let dictionaryMainVC = DIContainer.resolve(type: DictionaryMainViewFactory.self).make()

        let bookmarkMainVC = DIContainer.resolve(type: BookmarkMainFactory.self).make()

        let dictView = BottomTabBarController(viewControllers: [
            dictionaryMainVC,
            bookmarkMainVC,
            BaseViewController()
        ])
        dictView.title = "도감 메인"

        return [
            modalVC,
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
        if indexPath.section == 0 {
            if nextController.title == "몬스터 필터 바텀시트" || nextController.title == "정렬 바텀시트" {
                if let nextVC = nextController as? (UIViewController & ModalPresentable) {
                    presentModal(nextVC)
                }
            } else {
                navigationController?.present(nextController, animated: true)
            }
        } else if indexPath.section == 1 {
            nextController.modalPresentationStyle = .fullScreen
            navigationController?.present(nextController, animated: true)
        } else {
            navigationController?.pushViewController(nextController, animated: true)
        }
    }
}
