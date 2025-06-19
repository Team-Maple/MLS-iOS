import UIKit

import BaseFeature
import DomainInterface

import ReactorKit
import RxSwift

public final class DictionaryListViewController: BaseViewController, View {
    public typealias Reactor = DictionaryListReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()
    var type: DictionaryType

    // MARK: - Components
    private let mainView: DictionaryListView

    public init(type: DictionaryType) {
        self.type = type
        self.mainView = DictionaryListView(isFilterHidden: type.isFilterHidden)
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.refresh)
    }
}

// MARK: - SetUp
private extension DictionaryListViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        mainView.listCollectionView.collectionViewLayout = createListLayout()
        mainView.listCollectionView.delegate = self
        mainView.listCollectionView.dataSource = self
        mainView.listCollectionView.register(DictionaryListCell.self, forCellWithReuseIdentifier: DictionaryListCell.identifier)
    }

    func createListLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getPageListLayout() }
            .build()
        layout.register(Neutral300DividerView.self, forDecorationViewOfKind: Neutral300DividerView.identifier)
        return layout
    }
}

// MARK: - Bind
extension DictionaryListViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)

        reactor.action.onNext(.load)
    }

    func bindUserActions(reactor: Reactor) {}

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.items)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                self?.mainView.listCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension DictionaryListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reactor?.currentState.items.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DictionaryListCell.identifier,
                for: indexPath
            ) as? DictionaryListCell,
            let item = reactor?.currentState.items[indexPath.row]
        else {
            return UICollectionViewCell()
        }

        cell.inject(
            input: DictionaryListCell.Input(
                type: item.type,
                mainText: item.mainText,
                subText: item.subText,
                image: item.image,
                isBookmarked: item.isBookmarked
            ),
            onBookmarkTapped: { [weak self] in
                guard let self = self else { return }
                if item.isBookmarked {
                    self.reactor?.action.onNext(.toggleBookmark(item.id))
                } else {
                    GuideAlertFactory.show(
                        mainText: "북마크를 하려면 로그인이 필요해요.",
                        ctaText: "로그인 하기",
                        cancelText: "취소",
                        ctaAction: {
                            print("로그인 화면으로 이동")
                        },
                        cancelAction: {
                            print("취소됨")
                        }
                    )
                }
            }
        )

        return cell
    }
}
