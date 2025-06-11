import UIKit

import BaseFeature

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final public class ItemFilterBottomSheetViewController: BaseViewController, View {
    
    public typealias Reactor = ItemFilterBottomSheetViewReactor

    enum Section: Int, CaseIterable {
        case category
        case job
    }

    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    private var mainView = ItemFilterBottomSheetView()
    
    public override init() {
        super.init()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension ItemFilterBottomSheetViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension ItemFilterBottomSheetViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        mainView.contentCollectionView.collectionViewLayout = createLayout()
        mainView.contentCollectionView.delegate = self
        mainView.contentCollectionView.dataSource = self
        mainView.contentCollectionView.register(PageTabbarCell.self, forCellWithReuseIdentifier: PageTabbarCell.identifier)
        mainView.contentCollectionView.selectItem(at: .init(row: 0, section: 0), animated: false, scrollPosition: .bottom)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            switch sectionKind {
            case .category:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(100),
                    heightDimension: .absolute(40)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(100),
                    heightDimension: .absolute(40)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 20
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
                // ✅ Decoration item 추가
                let divider = NSCollectionLayoutDecorationItem.background(elementKind: PageTabbarDividerView.identifier)
                divider.contentInsets = .init(top: 39, leading: 0, bottom: 0, trailing: 0) // 섹션 아래 위치
                section.decorationItems = [divider]
                return section
            case .job:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(100),
                    heightDimension: .absolute(40)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(100),
                    heightDimension: .absolute(40)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 20
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
                // ✅ Decoration item 추가
                let divider = NSCollectionLayoutDecorationItem.background(elementKind: PageTabbarDividerView.identifier)
                divider.contentInsets = .init(top: 39, leading: 0, bottom: 0, trailing: 0) // 섹션 아래 위치
                section.decorationItems = [divider]
                return section
            }
        }
        layout.register(PageTabbarDividerView.self, forDecorationViewOfKind: PageTabbarDividerView.identifier)
        return layout
    }
}

extension ItemFilterBottomSheetViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    
    func bindUserActions(reactor: Reactor) {
        mainView.headerView.firstIconView.rx.tap
            .map { Reactor.Action.closeButtonTapped }
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
                    owner.dismiss(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

    }
}

extension ItemFilterBottomSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        switch Section(rawValue: section)! {
        case .category:
            return reactor.currentState.sections.count
        case .job:
            return reactor.currentState.jobs.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reactor = reactor else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageTabbarCell.identifier, for: indexPath) as? PageTabbarCell else { return UICollectionViewCell() }
        switch Section(rawValue: indexPath.section)! {
        case .category:
            let title = reactor.currentState.sections[indexPath.row]
            cell.configure(title: title)
        case .job:
            let title = reactor.currentState.jobs[indexPath.row]
            cell.configure(title: title)
        }
        cell.layer.cornerRadius = 8
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // animation update
//        collectionView.performBatchUpdates { }
        // normal update
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

final class PageTabbarDividerView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .neutral500
        layer.zPosition = -1 // 셀 뒤로 보내기
        print("asd;lkfja;sdlfk")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        // 보통 라인은 1pt 높이로 처리
        self.frame.size.height = 1
    }
}
