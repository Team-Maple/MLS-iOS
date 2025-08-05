import UIKit

import DesignSystem

import RxSwift
import SnapKit

final class TextButtonTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()

    let button = TextButton()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "TextButton"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension TextButtonTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteMLS
        addViews()
        setupConstraints()
    }
}

// MARK: - SetUp
private extension TextButtonTestViewController {
    func addViews() {
        view.addSubview(button)
    }

    func setupConstraints() {
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
