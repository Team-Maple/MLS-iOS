import UIKit

import RxCocoa
import RxSwift

final class TooltipOverlayView: UIView {
    // MARK: - Properties
    private let disposeBag = DisposeBag()

    var onDismiss: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.onDismiss?()
            }
            .disposed(by: disposeBag)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
