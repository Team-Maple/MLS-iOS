import UIKit

import DesignSystem

import RxSwift
import SnapKit

public final class TagChipCell: UICollectionViewCell {
    // MARK: - Properties
    public let buttonTapSubject = PublishSubject<Void>()
    public let cancelButtonTapSubject = PublishSubject<Void>()

    // MARK: - Components
    public let button: TagChip = {
        let button = TagChip(style: .normal, text: "")
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
    }

    public var disposeBag = DisposeBag()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: - SetUp
private extension TagChipCell {
    func addViews() {
        contentView.addSubview(button)
    }

    func setupConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bind() {
        button.rx.tap
            .bind(to: buttonTapSubject)
            .disposed(by: disposeBag)

        button.cancelButton.rx.tap
            .bind(to: cancelButtonTapSubject)
            .disposed(by: disposeBag)
    }
}

public extension TagChipCell {
    func inject(title: String?, style: TagChip.TagChipStyle) {
        bind()
        button.style = style
        button.text = title ?? ""
        button.titleLabel?.numberOfLines = 1
    }
}
