import DictionaryFeatureInterface
import UIKit

import BaseFeature
import DesignSystem
import DomainInterface

import ReactorKit
import RxSwift

public final class DictionarySearchViewController: BaseViewController, View {
    public typealias Reactor = DictionarySearchReactor

    // MARK: - Properties
    private var searchResultFactory: DictionarySearchResultFactory

    public var disposeBag = DisposeBag()

    // MARK: - Components
    private let mainView = DictionarySearchView()

    public init(searchResultFactory: DictionarySearchResultFactory) {
        self.searchResultFactory = searchResultFactory
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension DictionarySearchViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        isBottomTabbarHidden = true

        mainView.searchCollectionView.collectionViewLayout = createLayout()
        mainView.searchCollectionView.delegate = self
        mainView.searchCollectionView.dataSource = self
        mainView.searchCollectionView.register(TagChipCell.self, forCellWithReuseIdentifier: TagChipCell.identifier)
        mainView.searchCollectionView.register(PopularResultCell.self, forCellWithReuseIdentifier: PopularResultCell.identifier)
        mainView.searchCollectionView.register(
            RecentSearchHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: RecentSearchHeaderView.identifier
        )
        mainView.searchCollectionView.register(
            PopularSearchHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PopularSearchHeaderView.identifier
        )
    }

    func createLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()

        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self,
                  let reactor = self.reactor else {
                return NSCollectionLayoutSection(
                    group: NSCollectionLayoutGroup.vertical(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1)),
                        subitems: []
                    )
                )
            }

            if reactor.currentState.hasRecent {
                switch sectionIndex {
                case 0:
                    return layoutFactory.getTagChipLayout().build()!
                case 1:
                    return layoutFactory.getDecorationSection().build()!
                case 2:
                    return layoutFactory.getPopularResultLayout(hasRecent: true).build()!
                default:
                    return nil
                }
            } else {
                switch sectionIndex {
                case 0:
                    return layoutFactory.getPopularResultLayout(hasRecent: false).build()!
                default:
                    return nil
                }
            }
        }

        layout.register(SearchDividerView.self, forDecorationViewOfKind: SearchDividerView.identifier)
        return layout
    }
}

// MARK: - Bind
extension DictionarySearchViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.searchBar.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.searchBar.searchButton.rx.tap
            .map { Reactor.Action.searchButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in return reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { (owner, route) in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .search:
                    guard let keyword = owner.mainView.searchBar.textField.text else { return }
                    if keyword.isOnlyKorean() && keyword != "" {
                        GuideAlertFactory.show(mainText: "초성은 검색할 수 없습니다.", ctaText: "확인", ctaAction: {})
                    } else {
                        owner.mainView.searchBar.textField.text = ""
                        let viewController = owner.searchResultFactory.make(keyword: keyword)
                        owner.navigationController?.pushViewController(viewController, animated: true)
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension DictionarySearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return reactor?.currentState.hasRecent == true ? 3 : 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }

        if reactor.currentState.hasRecent {
            switch section {
            case 0:
                return reactor.currentState.recentResult.count
            case 2:
                return reactor.currentState.popularResult.count
            default:
                return 0
            }
        } else {
            switch section {
            case 0:
                return reactor.currentState.popularResult.count
            default:
                return 0
            }
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reactor = reactor else { return UICollectionViewCell() }

        let section = indexPath.section

        if reactor.currentState.hasRecent {
            switch section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagChipCell.identifier, for: indexPath) as! TagChipCell
                let item = reactor.currentState.recentResult[indexPath.item]
                cell.button.style = .search
                cell.inject(title: item)
                return cell

            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularResultCell.identifier, for: indexPath) as! PopularResultCell
                let item = reactor.currentState.popularResult[indexPath.item]
                cell.inject(input: .init(text: item, index: indexPath.item))
                return cell

            default:
                return UICollectionViewCell()
            }
        } else {
            switch section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularResultCell.identifier, for: indexPath) as! PopularResultCell
                let item = reactor.currentState.popularResult[indexPath.item]
                cell.inject(input: .init(text: item, index: indexPath.item))
                return cell

            default:
                return UICollectionViewCell()
            }
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let reactor = reactor else { return UICollectionReusableView() }

        switch indexPath.section {
        case 0 where reactor.currentState.hasRecent:
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RecentSearchHeaderView.identifier,
                for: indexPath
            ) as! RecentSearchHeaderView
            return view

        case reactor.currentState.hasRecent ? 2 : 0:
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PopularSearchHeaderView.identifier,
                for: indexPath
            ) as! PopularSearchHeaderView
            view.inject(mainText: "인기 검색어", subText: "업데이트 일자", hasRecent: reactor.currentState.hasRecent)
            return view

        default:
            return UICollectionReusableView()
        }
    }
}
