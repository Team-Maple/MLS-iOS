import UIKit

import BaseFeature
import DesignSystem
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class SortedBottomSheetViewController: BaseViewController, ModalPresentable, View {
    public var modalHeight: CGFloat?

    public typealias Reactor = SortedBottomSheetReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    public var onSelectedIndex: ((Int) -> Void)?

    // MARK: - Components

    private var mainView = SortedBottomSheetView()
}

// MARK: - Life Cycle
public extension SortedBottomSheetViewController {
    override func viewDidLoad() {
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

    private func updateSortedButtons(types: [SortType]) {
        mainView.sortedStackView.arrangedSubviews.forEach {
            mainView.sortedStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        guard let reactor = reactor else { return }
        mainView.sortedButtons = types.enumerated().map { index, type in
            let button = CheckBoxButton(style: .listLarge, mainTitle: type.rawValue, subTitle: nil)

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

        mainView.applyButton.rx.tap
            .map { Reactor.Action.applyButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map { $0.sortTypes }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, type in
                owner.updateSortedButtons(types: type)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.selectedIndex }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, selectedIndex in
                owner.mainView.sortedButtons.enumerated().forEach { index, button in
                    button.isSelected = selectedIndex == index ? true : false
                }
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.isBottomTabbarHidden = reactor.currentState.isTabbarHidden
                    owner.dismissCurrentModal()
                case .dismissWithSave:
                    owner.isBottomTabbarHidden = reactor.currentState.isTabbarHidden
                    owner.onSelectedIndex?(reactor.currentState.selectedIndex)
                    owner.dismissCurrentModal()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
