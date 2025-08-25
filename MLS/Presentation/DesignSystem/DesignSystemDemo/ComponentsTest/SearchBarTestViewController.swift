import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

final class SearchBarTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()

    let searchBar: SearchBar = SearchBar()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "SearchBar"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension SearchBarTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addViews()
        self.setupConstraints()
        self.configureUI()
    }
}

// MARK: - SetUp
private extension SearchBarTestViewController {
    func addViews() {
        view.addSubview(searchBar)
    }

    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview()
        }
    }

    func configureUI() {
        self.view.backgroundColor = .systemBackground
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
}
