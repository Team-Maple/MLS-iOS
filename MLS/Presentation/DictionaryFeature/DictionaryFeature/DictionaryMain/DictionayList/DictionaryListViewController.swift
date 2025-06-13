import UIKit

import BaseFeature

import ReactorKit
import RxSwift

public final class DictionaryListViewController<T: DictionaryListReactorType>: BaseViewController, View, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public typealias Reactor = T
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    var type: DictionaryType
    
    // MARK: - Components
    private let mainView: DictionaryListView
    
    public init(type: DictionaryType) {
        self.type = type
        switch type {
        case .item, .monster:
            mainView = DictionaryListView(isFilterHidden: false)
        default:
            mainView = DictionaryListView(isFilterHidden: true)
        }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupConstraints()
        configureUI()
    }
 
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reactor = reactor else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictionaryListCell.identifier, for: indexPath) as? DictionaryListCell else {
            return UICollectionViewCell()
        }
        let item = reactor.currentState.items[indexPath.row]
        cell.inject(input: DictionaryListCell.Input(
            type: item.type,
            mainText: item.mainText,
            subText: item.subText,
            image: item.image,
            isBookmarked: item.isBookmarked
        ), onBookmarkTapped: {
            
        })
        return cell
    }
}

// MARK: - SetUp
private extension DictionaryListViewController {
    func addViews() {
        view.addSubview(mainView)
    }
    
    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        configureListCollectionView()
    }
    
    func configureListCollectionView() {
        mainView.listCollectionView.collectionViewLayout = createListLayout()
        mainView.listCollectionView.delegate = self
        mainView.listCollectionView.dataSource = self
        mainView.listCollectionView.register(DictionaryListCell.self, forCellWithReuseIdentifier: DictionaryListCell.identifier)
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in return layoutFactory.getPageListLayout() }
            .build()
        layout.register(PageTabbarDividerView.self, forDecorationViewOfKind: PageTabbarDividerView.identifier)
        return layout
    }
}

extension DictionaryListViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
  
    }

    func bindViewState(reactor: Reactor) {

    }
}
