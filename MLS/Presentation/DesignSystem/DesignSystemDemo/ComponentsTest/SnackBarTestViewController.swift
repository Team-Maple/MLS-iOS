import UIKit

import DesignSystem

import RxSwift
import SnapKit

final class SnackBarTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()

    let normalSnackBar = SnackBar(type: .normal, image: .appleLogo, imageBackgroundColor: .listNPC, text: "제목제목", buttonText: "되돌리기", buttonAction: nil)

    let deleteSnackBar = SnackBar(type: .delete, image: DesignSystemAsset.image(named: "testImage"), imageBackgroundColor: .listNPC, text: "제목제목", buttonText: "되돌리기", buttonAction: nil)

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "SnackBar"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension SnackBarTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension SnackBarTestViewController {
    func addViews() {
        view.addSubview(normalSnackBar)
        view.addSubview(deleteSnackBar)
    }

    func setupConstraints() {
        normalSnackBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
        }

        deleteSnackBar.snp.makeConstraints { make in
            make.top.equalTo(normalSnackBar.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        self.view.backgroundColor = .systemBackground

    }
}
