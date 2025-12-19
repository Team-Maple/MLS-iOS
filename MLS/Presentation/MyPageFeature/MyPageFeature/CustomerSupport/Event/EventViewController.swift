import DomainInterface
import ReactorKit
import UIKit

final class EventViewController: CustomerSupportBaseViewController, View {
    typealias Reactor = EventReactor

    // MARK: - Init
    override init(type: CustomerSupportType) {
        super.init(type: type)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()

        onItemTapped = { [weak self] itemIndex in
            self?.reactor?.action.onNext(.itemTapped(itemIndex))
        }

        onLoadMore = { [weak self] in
            self?.reactor?.action.onNext(.loadMore)
        }
    }

    // MARK: - Setup
    private func setupMenu() {
        let ongoingButton = mainView.createMenuButton(title: "진행중인 이벤트", tag: 0)
        let endedButton = mainView.createMenuButton(title: "종료된 이벤트", tag: 1)

        mainView.menuStackView.addArrangedSubview(ongoingButton)
        mainView.menuStackView.addArrangedSubview(endedButton)
        mainView.setupSpacerView()

        reactor?.action.onNext(.selectTab(0))

        guard let reactor = reactor else { return }
        mainView.menuStackView.arrangedSubviews
            .compactMap { $0 as? UIButton }
            .forEach { button in
                button.rx.tap
                    .map { Reactor.Action.selectTab(button.tag) }
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
            }
    }
}

// MARK: - Bind
extension EventViewController {
    func bind(reactor: Reactor) {
        bindViewState(reactor: reactor)
    }

    private func bindViewState(reactor: Reactor) {
        reactor.state.map(\.selectedIndex)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] selectedIndex in
                guard let self else { return }
                self.updateButtonStates(in: self.mainView.menuStackView, selectedTag: selectedIndex)
            }
            .disposed(by: disposeBag)

        reactor.state.map(\.alarms)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] items in
                guard let self else { return }
                self.mainView.detailItemStackView.arrangedSubviews.forEach { subview in
                    self.mainView.detailItemStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
                let eventType = reactor.currentState.selectedIndex == 0 ? "진행중인" : "종료된"
                if items.isEmpty {
                    self.mainView.setEmpty(text: "\(eventType) 이벤트가 없습니다.")
                } else {
                    self.createDetailItem(items: items)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods
private extension EventViewController {
    private func updateButtonStates(in stackView: UIStackView, selectedTag: Int) {
        for (index, subview) in stackView.arrangedSubviews.enumerated() {
            guard let button = subview as? UIButton else { continue }
            let title = button.titleLabel?.text ?? ""
            let underline = button.subviews.first { $0.tag == 999999 }

            if index == selectedTag {
                button.setAttributedTitle(.makeStyledString(font: .sub_m_b, text: title, color: .black), for: .normal)
                underline?.isHidden = false
            } else {
                button.setAttributedTitle(.makeStyledString(font: .b_m_r, text: title, color: .neutral600), for: .normal)
                underline?.isHidden = true
            }
        }
    }
}
