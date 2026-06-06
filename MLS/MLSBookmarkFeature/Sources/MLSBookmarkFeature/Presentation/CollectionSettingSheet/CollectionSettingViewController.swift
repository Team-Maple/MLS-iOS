import MLSBookmarkFeatureInterface
import MLSCore
import MLSDesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class CollectionSettingViewController: BaseViewController, ModalPresentable, View {
    var modalHeight: CGFloat? = 284

    typealias Reactor = CollectionSettingReactor

    var disposeBag = DisposeBag()
    var setMenu: ((CollectionSettingMenu) -> Void)?

    private var mainView = CollectionSettingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainView.menuTableView.delegate = self
        mainView.menuTableView.dataSource = self
    }

    func bind(reactor: Reactor) {
        mainView.header.firstIconButton.rx.tap
            .map { Reactor.Action.cancelButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.dismissCurrentModal()
                case .dismissWithMenu(let menu):
                    owner.setMenu?(menu)
                    owner.dismissCurrentModal()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

extension CollectionSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reactor?.currentState.menu.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let item = reactor?.currentState.menu[indexPath.row] else { return cell }
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.textLabel?.attributedText = .makeStyledString(font: .b_m_r, text: item.title, color: item.titleColor)
        if indexPath.row < (reactor?.currentState.menu.count ?? 0) - 1 {
            let divider = UIView()
            divider.backgroundColor = .lightGray.withAlphaComponent(0.3)
            cell.contentView.addSubview(divider)
            divider.snp.makeConstraints { make in
                make.horizontalEdges.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = reactor?.currentState.menu[indexPath.row] else { return }
        switch item {
        case .editBookmark: reactor?.action.onNext(.editBookmarkButtonTapped)
        case .editName: reactor?.action.onNext(.editNameButtonTapped)
        case .delete: reactor?.action.onNext(.deleteButtonTapped)
        case .cancel: reactor?.action.onNext(.cancelButtonTapped)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
}
