import UIKit

import AuthFeature

import RxCocoa
import RxSwift
import SnapKit

class ViewController: UIViewController {
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()
    
    lazy var views: [UIViewController] = {
        let loginVC = LoginViewController(isRelogin: false, termsAgreementsFactory: TermsAgreementFactoryImpl())
        loginVC.title = "로그인"
        
        let termVC = TermsAgreementViewController()
        termVC.reactor = TermsAgreementReactor()
        termVC.title = "약관 동의"
        
        let questionVC = OnBoardingQuestionViewController(factory: OnBoardingQuestionFactoryImpl())
        questionVC.reactor = OnBoardingQuestionReactor()
        questionVC.title = "온보딩 진입"
        
        let inputVC = OnBoardingInputViewController(factory: OnBoardingInputFactoryImpl())
        inputVC.reactor = OnBoardingInputReactor()
        inputVC.title = "온보딩 입력"
        
        let notiVC = OnBoardingNotificationViewController(factory: OnBoardingNotificationFactoryImpl())
        notiVC.reactor = OnBoardingNotificationReactor()
        notiVC.title = "온보딩 알림"
        
        return [
            loginVC,
            termVC,
            questionVC,
            inputVC,
            notiVC,
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
