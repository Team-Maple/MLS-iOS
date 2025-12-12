import UIKit

import BaseFeature
import DesignSystem

import ReactorKit
import RxKeyboard
import RxSwift
import SnapKit

public final class MonsterFilterBottomSheetViewController: BaseViewController, ModalPresentable, View {
    public var modalHeight: CGFloat?

    public typealias Reactor = MonsterFilterBottomSheetReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    var startLevel: CGFloat = 1
    var endLevel: CGFloat = 200

    public lazy var mainView = MonsterFilterBottomSheetView(lowerLevel: startLevel, upperLevel: endLevel)

    public var onFilterSelected: ((Int, Int) -> Void)?
}

// MARK: - Life Cycle
public extension MonsterFilterBottomSheetViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
        setupKeyboard()
    }
}

// MARK: - SetUp
private extension MonsterFilterBottomSheetViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {}

    func setupKeyboard() {
        setupKeyboard { [weak self] height in
            self?.mainView.snp.remakeConstraints { make in
                make.top.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().inset(height)
            }
        }
    }
}

extension MonsterFilterBottomSheetViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.header.firstIconButton.rx.tap
            .map { Reactor.Action.cancelButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.clearButton.rx.tap
            .map { Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.applyButton.rx.tap
            .withUnretained(self)
            .compactMap { _, _ in
                let startText = (self.mainView.levelRangeView.leftInputBox.textField.text?.isEmpty == false)
                    ? self.mainView.levelRangeView.leftInputBox.textField.text!
                    : "1"

                let endText = (self.mainView.levelRangeView.rightInputBox.textField.text?.isEmpty == false)
                    ? self.mainView.levelRangeView.rightInputBox.textField.text!
                    : "200"
                guard let start = Int(startText),
                      let end = Int(endText)
                else {
                    return nil
                }
                return Reactor.Action.applyButtonTapped(start: start, end: end)
            }
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
                case .dismissWithLevelRange(let start, let end):
                    owner.onFilterSelected?(start, end)
                    owner.dismissCurrentModal()
                case .clear:
                    owner.mainView.levelRangeView.slider.reset(lower: 1, upper: 200)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        mainView.tapGesture.rx.event
            .withUnretained(self)
            .bind { owner, gesture in
                let location = gesture.location(in: owner.mainView)

                if !owner.mainView.levelRangeView.leftInputBox.frame.contains(location),
                   !owner.mainView.levelRangeView.rightInputBox.frame.contains(location) {
                    owner.mainView.endEditing(true)
                }
            }
            .disposed(by: disposeBag)
    }
}
