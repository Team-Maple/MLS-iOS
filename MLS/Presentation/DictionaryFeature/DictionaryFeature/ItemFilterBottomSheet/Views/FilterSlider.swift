import UIKit

import RxCocoa
import RxSwift
import SnapKit

public class FilterSlider: UIControl {
    // MARK: - Constants
    private enum Constant {
        static let thumbSize: CGFloat = 26
        static let trackHeight: CGFloat = 8
        static let trackCornerRadius: CGFloat = 4
        static let thumbCornerRadius: CGFloat = thumbSize / 2
        static let thumbBorderWidth: CGFloat = 1
        static let thumbShadowOpacity: Float = 1
        static let thumbShadowRadius: CGFloat = 10
        static let thumbShadowOffset = CGSize(width: 4, height: 4)
        static let expandedTouchInset: CGFloat = -10
        static let animationDuration: TimeInterval = 0.25
    }

    // MARK: - Value Relays
    private let minimumValueRelay = BehaviorRelay<CGFloat>(value: 0)
    private let maximumValueRelay = BehaviorRelay<CGFloat>(value: 200)
    private let lowerValueRelay = BehaviorRelay<CGFloat>(value: 0)
    private let upperValueRelay = BehaviorRelay<CGFloat>(value: 200)

    // MARK: - Public properties
    public var minimumValue: CGFloat {
        get { minimumValueRelay.value }
        set { minimumValueRelay.accept(newValue) }
    }

    public var maximumValue: CGFloat {
        get { maximumValueRelay.value }
        set { maximumValueRelay.accept(newValue) }
    }

    public var lowerValue: CGFloat {
        get { lowerValueRelay.value }
        set { lowerValueRelay.accept(boundValue(newValue, lower: minimumValue, upper: maximumValue)) }
    }

    public var upperValue: CGFloat {
        get { upperValueRelay.value }
        set { upperValueRelay.accept(boundValue(newValue, lower: minimumValue, upper: maximumValue)) }
    }

    public let isThumbTracking: BehaviorRelay<Bool> = .init(value: false)

    // MARK: - Observables
    public var minimumValueObservable: Observable<CGFloat> { minimumValueRelay.asObservable() }
    public var maximumValueObservable: Observable<CGFloat> { maximumValueRelay.asObservable() }
    public var lowerValueObservable: Observable<CGFloat> { lowerValueRelay.asObservable() }
    public var upperValueObservable: Observable<CGFloat> { upperValueRelay.asObservable() }

    // MARK: - UI Elements
    private let trackView = UIView()
    private let selectedTrackView = UIView()
    private let lowerThumb = UIView()
    private let upperThumb = UIView()

    private var previousLocation = CGPoint.zero

    private var selectedTrackLeadingConstraint: Constraint?
    private var selectedTrackTrailingConstraint: Constraint?
    private var lowerThumbCenterX: Constraint?
    private var upperThumbCenterX: Constraint?

    private enum Thumb {
        case lower, upper, none
    }

    private var activeThumb: Thumb = .none

    private let disposeBag = DisposeBag()

    // MARK: - Init
    public init(
        minimumValue: CGFloat,
        maximumValue: CGFloat,
        initialLowerValue: CGFloat,
        initialUpperValue: CGFloat
    ) {
        super.init(frame: .zero)

        minimumValueRelay.accept(minimumValue)
        maximumValueRelay.accept(maximumValue)

        lowerValueRelay.accept(boundValue(initialLowerValue, lower: minimumValue, upper: maximumValue))
        upperValueRelay.accept(boundValue(initialUpperValue, lower: minimumValue, upper: maximumValue))

        setup()
        bindValues()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        bindValues()
    }

    // MARK: - Setup UI
    private func setup() {
        trackView.backgroundColor = .neutral200
        trackView.layer.cornerRadius = Constant.trackCornerRadius
        addSubview(trackView)
        trackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(Constant.trackHeight)
        }

        selectedTrackView.backgroundColor = .primary700
        selectedTrackView.layer.cornerRadius = Constant.trackCornerRadius
        addSubview(selectedTrackView)
        selectedTrackView.snp.makeConstraints { make in
            make.centerY.equalTo(trackView)
            make.height.equalTo(Constant.trackHeight)
            selectedTrackLeadingConstraint = make.leading.equalToSuperview().constraint
            selectedTrackTrailingConstraint = make.trailing.equalToSuperview().constraint
        }

        [lowerThumb, upperThumb].forEach {
            $0.backgroundColor = .whiteMLS
            $0.layer.borderColor = UIColor.neutral200.cgColor
            $0.layer.borderWidth = Constant.thumbBorderWidth
            $0.layer.cornerRadius = Constant.thumbCornerRadius
            $0.isUserInteractionEnabled = false
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
            $0.layer.shadowOpacity = Constant.thumbShadowOpacity
            $0.layer.shadowRadius = Constant.thumbShadowRadius
            $0.layer.shadowOffset = Constant.thumbShadowOffset
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(Constant.thumbSize)
                make.centerY.equalTo(trackView)
            }
        }

        lowerThumb.snp.makeConstraints { make in
            lowerThumbCenterX = make.centerX.equalToSuperview().constraint
        }
        upperThumb.snp.makeConstraints { make in
            upperThumbCenterX = make.centerX.equalToSuperview().constraint
        }
    }

    // MARK: - Bindings
    private func bindValues() {
        Observable.combineLatest(minimumValueRelay, maximumValueRelay)
            .subscribe(onNext: { [weak self] minVal, maxVal in
                guard let self = self else { return }
                let clampedLower = self.boundValue(self.lowerValueRelay.value, lower: minVal, upper: maxVal)
                let clampedUpper = self.boundValue(self.upperValueRelay.value, lower: minVal, upper: maxVal)
                if clampedLower != self.lowerValueRelay.value {
                    self.lowerValueRelay.accept(clampedLower)
                }
                if clampedUpper != self.upperValueRelay.value {
                    self.upperValueRelay.accept(clampedUpper)
                }
                self.animateUpdate()
            })
            .disposed(by: disposeBag)

        Observable.merge(lowerValueRelay.asObservable(), upperValueRelay.asObservable())
            .subscribe(onNext: { [weak self] _ in
                self?.animateUpdate()
                self?.sendActions(for: .valueChanged)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateTrackAndThumb(animated: false)
        lowerThumb.frame = lowerThumb.frame.integral
        upperThumb.frame = upperThumb.frame.integral
    }

    private func position(for value: CGFloat) -> CGFloat {
        guard maximumValue != minimumValue else { return Constant.thumbSize / 2 }
        let availableWidth = bounds.width - Constant.thumbSize
        return (value - minimumValue) / (maximumValue - minimumValue) * availableWidth + Constant.thumbSize / 2
    }

    private func updateTrackAndThumb(animated: Bool) {
        let lowerX = position(for: lowerValueRelay.value)
        let upperX = position(for: upperValueRelay.value)

        lowerThumbCenterX?.update(offset: lowerX - bounds.midX)
        upperThumbCenterX?.update(offset: upperX - bounds.midX)

        let minX = min(lowerX, upperX)
        let maxX = max(lowerX, upperX)

        selectedTrackLeadingConstraint?.update(offset: minX)
        selectedTrackTrailingConstraint?.update(offset: -(bounds.width - maxX))

        if animated {
            UIView.animate(withDuration: Constant.animationDuration, delay: 0, options: [.curveEaseInOut]) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }

    private func animateUpdate() {
        updateTrackAndThumb(animated: true)
    }

    private func boundValue(_ value: CGFloat, lower: CGFloat, upper: CGFloat) -> CGFloat {
        return min(max(value, lower), upper)
    }

    // MARK: - Touch Handling
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        isThumbTracking.accept(true)
        previousLocation = touch.location(in: self)

        if lowerThumb.frame.insetBy(dx: Constant.expandedTouchInset, dy: Constant.expandedTouchInset).contains(previousLocation) {
            activeThumb = .lower
        } else if upperThumb.frame.insetBy(dx: Constant.expandedTouchInset, dy: Constant.expandedTouchInset).contains(previousLocation) {
            activeThumb = .upper
        } else {
            activeThumb = .none
        }

        return activeThumb != .none
    }

    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        isThumbTracking.accept(true)
        let location = touch.location(in: self)
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / (bounds.width - Constant.thumbSize)
        previousLocation = location

        var newLower = lowerValueRelay.value
        var newUpper = upperValueRelay.value

        switch activeThumb {
        case .lower:
            newLower += deltaValue
        case .upper:
            newUpper += deltaValue
        case .none:
            break
        }

        newLower = boundValue(newLower, lower: minimumValue, upper: maximumValue)
        newUpper = boundValue(newUpper, lower: minimumValue, upper: maximumValue)

        if newLower > newUpper {
            lowerValueRelay.accept(newUpper)
            upperValueRelay.accept(newLower)
            activeThumb = (activeThumb == .lower) ? .upper : .lower
        } else {
            lowerValueRelay.accept(newLower)
            upperValueRelay.accept(newUpper)
        }

        return true
    }

    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isThumbTracking.accept(false)
        activeThumb = .none
    }

    // MARK: - Touch Hit Test
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if lowerThumb.frame.insetBy(dx: Constant.expandedTouchInset, dy: Constant.expandedTouchInset).contains(point) {
            return self
        }

        if upperThumb.frame.insetBy(dx: Constant.expandedTouchInset, dy: Constant.expandedTouchInset).contains(point) {
            return self
        }

        return super.hitTest(point, with: event)
    }
}

public extension FilterSlider {
    func reset(lower: CGFloat, upper: CGFloat) {
        lowerValueRelay.accept(boundValue(lower, lower: minimumValue, upper: maximumValue))
        upperValueRelay.accept(boundValue(upper, lower: minimumValue, upper: maximumValue))
        animateUpdate()
    }
}
