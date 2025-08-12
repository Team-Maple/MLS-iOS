import UIKit

import MypageFeature
import MypageFeatureInterface
import Core
import Data
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
        let mypageVC = DIContainer.resolve(type: MypageFactory.self).make()
        mypageVC.title = "마이페이지"
        
        return [mypageVC]
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

