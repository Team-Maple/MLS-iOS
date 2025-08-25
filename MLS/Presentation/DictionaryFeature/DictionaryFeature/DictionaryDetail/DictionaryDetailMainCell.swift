import UIKit

import BaseFeature
import DesignSystem
import DomainInterface

import RxCocoa
import RxSwift

final class DictionaryDetailMainCell: UICollectionViewCell {
    // MARK: - Type
    enum Constant {
        static let imageContentViewSize: CGFloat = 160
        static let imageRadius: CGFloat = 24
        static let bookmarkViewSize: CGFloat = 44
        static let bookmarkViewMargin: CGFloat = 6
        static let bookmarkViewInset: CGFloat = 10
        static let imageSize: CGFloat = 112
        static let imageTopMargin: CGFloat = 20
        static let imageBottomMargin: CGFloat = 12
        static let textMargin: CGFloat = 4
        static let horizontalInset: CGFloat = 16
        static let bottomMargin: CGFloat = 30
    }

    // MARK: - Properties
    private var onBookmarkTapped: (() -> Void)?
    private let disposeBag = DisposeBag()

    // MARK: - Components
    private let imageContentView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constant.imageRadius
        return view
    }()

    private let bookmarkContentView = UIView()
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "bookmarkGaryBorder"), for: .normal)
        return button
    }()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let subLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        configureUI()
        bindButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictionaryDetailMainCell {
    func addViews() {
        addSubview(imageContentView)
        imageContentView.addSubview(imageView)
        imageContentView.addSubview(bookmarkContentView)
        bookmarkContentView.addSubview(bookmarkButton)

        addSubview(nameLabel)
        addSubview(subLabel)
    }

    func setupConstraints() {
        imageContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.imageTopMargin)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constant.imageContentViewSize)
        }

        bookmarkContentView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Constant.bookmarkViewMargin)
            make.size.equalTo(Constant.bookmarkViewSize)
        }

        bookmarkButton.snp.makeConstraints { make in
            make.center.equalToSuperview().inset(Constant.bookmarkViewInset)
        }

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constant.imageSize)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageContentView.snp.bottom).offset(Constant.imageBottomMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constant.textMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.textMargin)
        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
    }

    func bindButton() {
        bookmarkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.onBookmarkTapped?()
            })
            .disposed(by: disposeBag)
    }

    /// 북마크 여부를 통해 아이콘 업데이트
    /// - Parameter isBookmarked: 북마크 여부
    func updateBookmarkButton(isBookmarked: Bool) {
        bookmarkButton.setImage(isBookmarked ? DesignSystemAsset.image(named: "bookmark") : DesignSystemAsset.image(named: "bookmarkGrayBorder"), for: .normal)
    }
}

extension DictionaryDetailMainCell {
    /// image: 메인 이미지
    /// backgroundColor: dictionaryItemType에 따른 배경색(.item / .monster etc..)
    /// name: 해당 dict 의 이름
    /// subText: level, 지역등 다양한 서브텍스트
    /// tags: 몬스터의 경우에만 사용되는 속성
    /// isBookmarked: 초기 북마크 UI설정을 위한 값
    struct Input {
        let image: UIImage?
        let backgroundColor: UIColor
        let name: String
        let subText: String?
        let tags: [String]
        let isBookmarked: Bool
        let onBookmarkTapped: (() -> Void)?
    }

    func inject(input: Input) {
        imageView.image = input.image
        imageContentView.backgroundColor = input.backgroundColor
        nameLabel.attributedText = .makeStyledString(font: .sub_l_m, text: input.name, color: .textColor)
        subLabel.attributedText = .makeStyledString(font: .b_s_r, text: input.subText, color: .neutral500)
        updateBookmarkButton(isBookmarked: input.isBookmarked)
        onBookmarkTapped = input.onBookmarkTapped
    }
}
