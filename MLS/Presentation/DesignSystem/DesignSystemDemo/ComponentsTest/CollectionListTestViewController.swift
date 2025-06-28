import UIKit

import DesignSystem

import RxSwift
import SnapKit

final class CollectionListTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()

    let collection = CollectionList()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "CollectionList"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension CollectionListTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addViews()
        self.setupConstraints()
        self.configureUI()
    }
}

// MARK: - SetUp
private extension CollectionListTestViewController {
    func addViews() {
        self.view.addSubview(collection)
    }

    func setupConstraints() {
        collection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configureUI() {
        self.view.backgroundColor = .neutral200
        collection.setTitle(text: "글자수는 10글자 이후부터 생략입니다.")
        collection.setSubtitle(text: "$n개")
    }
}
