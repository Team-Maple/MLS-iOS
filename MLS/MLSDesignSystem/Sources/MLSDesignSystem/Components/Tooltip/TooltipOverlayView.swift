import UIKit

import RxCocoa
import RxGesture
import RxSwift

internal final class TooltipOverlayView: UIView {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    let dismiss = PublishRelay<Void>()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: dismiss)
            .disposed(by: disposeBag)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
