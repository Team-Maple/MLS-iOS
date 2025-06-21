import UIKit

import BaseFeature
import DesignSystem

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final public class SortedBottomSheetViewController: BaseViewController, ModalPresentable, View {
    public var modalHeight: CGFloat?

    public typealias Reactor = SortedBottomSheetReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private var mainView = SortedBottomSheetView()

    var sortedButtons: [CheckBoxButton] = []
}

// MARK: - Life Cycle
extension SortedBottomSheetViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
    }
}

// MARK: - SetUp
private extension SortedBottomSheetViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func updateSortedButtons(_ options: [String]) {
        mainView.sortedStackView.arrangedSubviews.forEach {
            mainView.sortedStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        guard let reactor = reactor else { return }
        sortedButtons = options.enumerated().map { (index, title) in
            let button = CheckBoxButton(style: .listLarge, mainTitle: title, subTitle: nil)

            button.rx.tap
                .map { Reactor.Action.sortedButtonTapped(index: index) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)

            mainView.sortedStackView.addArrangedSubview(button)
            return button
        }
    }
}

extension SortedBottomSheetViewController {
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
        reactor.state
            .map { $0.sortedOptions }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { (owner, options) in
                owner.updateSortedButtons(options)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.selectedIndex }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { (owner, selectedIndex) in
                owner.sortedButtons.enumerated().forEach { (index, button) in
                    button.isSelected = selectedIndex == index ? true : false
                }
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in return reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { (owner, route) in
                switch route {
                case .dismiss:
                    owner.dismissCurrentModal()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
