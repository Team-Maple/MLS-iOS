import UIKit

import DesignSystem

import RxSwift
import SnapKit

final class ToastMakerTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()

    let toast = Toast(message: "토스트 테스트")

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Toast"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension ToastMakerTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteMLS
        addViews()
        setupConstraints()
    }
}

// MARK: - SetUp
private extension ToastMakerTestViewController {
    func addViews() {
        view.addSubview(toast)
    }

    func setupConstraints() {
        toast.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
