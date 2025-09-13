import UIKit

import BaseFeature

import ReactorKit
import RxSwift
import SnapKit

public final class SetProfileViewController: BaseViewController, View {
    // MARK: - Type
    enum Constant {
        static let bottomHeight: CGFloat = 64
    }

    public typealias Reactor = SetProfileReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    // MARK: - Components
    private let mainView = SetProfileView()

    // MARK: - Init
    override public init() {
        super.init()
        mainView.setName(name: "익명의 오무라이스케챱")
        mainView.setImage(image: .add)
        mainView.setPlatform(platform: .kakao)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - Setup
private extension SetProfileViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        view.backgroundColor = .neutral100
    }
}

// MARK: - Bind
extension SetProfileViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {}

    private func bindState(reactor: Reactor) {
        reactor.state
            .map(\.setProfileState)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, state in
                owner.mainView.setState(state: .edit)
            })
            .disposed(by: disposeBag)
    }
}
