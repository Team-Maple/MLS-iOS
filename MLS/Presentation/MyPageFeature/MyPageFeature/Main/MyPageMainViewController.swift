import UIKit

import BaseFeature

import ReactorKit
import RxSwift
import SnapKit

public final class MyPageMainViewController: BaseViewController, View {
    public typealias Reactor = MyPageMainReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    // MARK: - Components
    private let mainView = MyPageMainView()

    // MARK: - Init
    override public init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - Setup
private extension MyPageMainViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .neutral100
        mainView.mainCollectionView.collectionViewLayout = createListLayout()
        mainView.mainCollectionView.delegate = self
        mainView.mainCollectionView.dataSource = self
        mainView.mainCollectionView.register(MyPageMainCell.self, forCellWithReuseIdentifier: MyPageMainCell.identifier)
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()
        let layout = CompositionalLayoutBuilder()
            .section { _ in layoutFactory.getMyPageMainLayout() }
            .build()
        return layout
    }
}

// MARK: - Bind
extension MyPageMainViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {
        
    }

    private func bindState(reactor: Reactor) {
        
    }
}

// MARK: - Delegate
extension MyPageMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageMainCell.identifier, for: indexPath) as? MyPageMainCell else { return UICollectionViewCell() }
        cell.inject(input: MyPageMainCell.Input(image: .checkmark, name: "익명의 오무라이스케챱"))
        return cell
    }
}
