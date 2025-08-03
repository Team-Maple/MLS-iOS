import UIKit

import DesignSystem

import RxSwift
import SnapKit

final class DictionarySearchView: UIView {
    // MARK: - Type
    enum Constant {
        static let searchBarTopMargin: CGFloat = 12
        static let collectionViewTopMargin: CGFloat = 20
        static let horizontalMargin: CGFloat = 16
        static let collectionViewSpacing: CGFloat = 10
    }

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - Components
    public let searchBar = SearchBar()

    public let searchCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
        setupKeyboard()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - SetUp
private extension DictionarySearchView {
    func addViews() {
        addSubview(searchBar)
        addSubview(searchCollectionView)
    }

    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.searchBarTopMargin)
            make.horizontalEdges.equalToSuperview()
        }

        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Constant.collectionViewTopMargin)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .clearMLS
    }

    func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}
