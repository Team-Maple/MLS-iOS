import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import SnapKit

final class NavigationBarTestViewController: UIViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()

    private let headerView1: NavigationBar = {
        let view = NavigationBar(type: .withUnderLine("null"))
        return view
    }()

    private let headerView2: NavigationBar = {
        let view = NavigationBar(type: .arrowRightLeft)
        return view
    }()

    private let headerView3: NavigationBar = {
        let view = NavigationBar(type: .arrowLeft)
        return view
    }()

    private let headerView4: NavigationBar = {
        let view = NavigationBar(type: .withString("null"))
        return view
    }()

    private let headerView5: NavigationBar = {
        let view = NavigationBar(type: .collection("컬렉션 이름"))
        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "NavigationBar"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension NavigationBarTestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension NavigationBarTestViewController {
    func addViews() {
        view.addSubview(headerView1)
        view.addSubview(headerView2)
        view.addSubview(headerView3)
        view.addSubview(headerView4)
        view.addSubview(headerView5)
    }

    func setupConstraints() {
        headerView1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        headerView2.snp.makeConstraints { make in
            make.top.equalTo(headerView1.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        headerView3.snp.makeConstraints { make in
            make.top.equalTo(headerView2.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        headerView4.snp.makeConstraints { make in
            make.top.equalTo(headerView3.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        headerView5.snp.makeConstraints { make in
            make.top.equalTo(headerView4.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}
