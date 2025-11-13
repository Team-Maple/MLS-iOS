import UIKit

import BaseFeature
import BookmarkFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class CollectionSettingViewController: BaseViewController, ModalPresentable, View {
    public var modalHeight: CGFloat? = 284

    public typealias Reactor = CollectionSettingReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    public var setMenu: ((CollectionSettingMenu) -> Void)?

    private var mainView = CollectionSettingView()
}

// MARK: - Life Cycle
public extension CollectionSettingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension CollectionSettingViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        mainView.menuTableView.delegate = self
        mainView.menuTableView.dataSource = self
    }
}

extension CollectionSettingViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.header.firstIconButton.rx.tap
            .map { Reactor.Action.cancelButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
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
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.menu.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let reactor = reactor else { return cell }
        let item = reactor.currentState.menu[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.textLabel?.attributedText = .makeStyledString(font: .b_m_r, text: item.title, color: item.titleColor)
        if indexPath.row < reactor.currentState.menu.count - 1 {
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

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let reactor = reactor else { return }
        let item = reactor.currentState.menu[indexPath.row]
        switch item {
        case .editBookmark:
            reactor.action.onNext(.editBookmarkButtonTapped)
        case .editName:
            reactor.action.onNext(.editNameButtonTapped)
        case .delete:
            reactor.action.onNext(.deleteButtonTapped)
        case .cancel:
            reactor.action.onNext(.cancelButtonTapped)
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}
