import UIKit

import DesignSystem

internal import RxCocoa
internal import RxSwift
internal import SnapKit

public class CustomNavigationController: UINavigationController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - Components
    private var leftButton: UIBarButtonItem {
        let imageView = UIImageView(image: DesignSystemAsset.image(named: "arrowLeft"))
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        return UIBarButtonItem(customView: imageView)
    }

    let rightButton = UIBarButtonItem(title: "다음에 하기", style: .plain, target: nil, action: nil)
}

// MARK: - Life Cycle
public extension CustomNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarIfNeeded()
    }
}

// MARK: - SetUp
private extension CustomNavigationController {
    private func setupNavigationBar() {
        navigationBar.backgroundColor = .white

        updateNavigationBarIfNeeded()
    }

    private func updateNavigationBarIfNeeded() {
        guard let topVC = topViewController else { return }

        leftButton.tintColor = .black
        rightButton.tintColor = .gray
        
        guard let font = UIFont.body else { return }
        rightButton.setTitleTextAttributes([NSAttributedString.Key.font: font, .underlineStyle: NSUnderlineStyle.single.rawValue], for: .normal)

        topVC.navigationItem.leftBarButtonItem = leftButton
        topVC.navigationItem.rightBarButtonItem = rightButton

        leftButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        rightButton.rx.tap
            .subscribe(onNext: {
//                setViewControllers([/*VC*/], animated: true)
            })
            .disposed(by: disposeBag)
    }
}
