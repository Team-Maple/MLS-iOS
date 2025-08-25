import UIKit

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

    let bottomTabBarViewController = BottomTabBarController(viewControllers: [
        CheckBoxButtonTestViewController(),
        NavigationBarTestViewController(),
        CommonButtonTestViewController(),
        InputBoxTextViewController()
    ], initialIndex: 1)

    lazy var componentViews: [UIViewController] = [
        CheckBoxButtonTestViewController(),
        NavigationBarTestViewController(),
        CommonButtonTestViewController(),
        InputBoxTextViewController(),
        DropDownBoxTextViewController(),
        ToastMakerTestViewController(),
        ErrorMessageTextViewController(),
        StepIndicatorTestViewController(),
        HeaderTestViewController(),
        TapButtonTestViewController(),
        TagChipTestViewController(),
        GuideAlertTestViewController(),
        CardListTestViewController(),
        bottomTabBarViewController,
        SearchBarTestViewController(),
        CollectionListTestViewController(),
        SnackBarTestViewController(),
        BadgeTestController(),
        DictionaryDetailViewTestController(),
        TextButtonTestViewController()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "MLS Design System"
        bottomTabBarViewController.title = "BottomTabBar"

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
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return componentViews.count
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
        default:
            return
        }

        navigationController?.pushViewController(nextController, animated: true)
    }
}
