import UIKit

import Data

import RxCocoa
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    let button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.setTitle("Kakao Login", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindActions()
    }

    private func setupUI() {
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func bindActions() {
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }

    @objc private func handleLogin() {
        print("handleLogin called")
        let kakaoLoginProvider = KakaoLoginProviderImpl()
        kakaoLoginProvider.getCredential()
            .subscribe(onNext: { credential in
                print("Credential received: \(credential)")
            }, onError: { error in
                print("Login error: \(error)")
            }, onDisposed: {
                print("Subscription disposed")
            })
            .disposed(by: disposeBag)
    }
}
