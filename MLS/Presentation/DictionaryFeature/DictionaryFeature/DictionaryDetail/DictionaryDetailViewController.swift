import UIKit

import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class DictionaryDetailViewController: BaseViewController, View {
    public typealias Reactor = DictionaryDetailReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    // MARK: - Components
    private var mainView = DictionaryDetailView()

    public init(text: String) {
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
private extension DictionaryDetailViewController {
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
        mainView.detailCollectionView.collectionViewLayout = createLayout()
        mainView.detailCollectionView.delegate = self
        mainView.detailCollectionView.dataSource = self
        // 이미지, 이름, 서브텍스트를 구성하는 메인셀
        mainView.detailCollectionView.register(DictionaryDetailMainCell.self, forCellWithReuseIdentifier: DictionaryDetailMainCell.identifier)
        // 몬스터 속성을 구성하는 뱃지셀
        mainView.detailCollectionView.register(BadgeCell.self, forCellWithReuseIdentifier: BadgeCell.identifier)
        // 탭부터 하단뷰를 구성하는 셀
        mainView.detailCollectionView.register(DictionaryDetailDescriptionCell.self, forCellWithReuseIdentifier: DictionaryDetailDescriptionCell.identifier)
        // descriptionCell에서 사용하는 Header
        mainView.detailCollectionView.register(DictionaryDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DictionaryDetailHeaderView.identifier)
    }

    func createLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()

        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return layoutFactory.getDictionaryDetailMainLayout().build()!
            case 1:
                return layoutFactory.getBadgeLayout().build()
            default:
                return layoutFactory.getDictionaryDetailDescriptionLayout().build()
            }
        }
        // 뱃지셀의 배경뷰
        layout.register(WhiteBackgroundView.self, forDecorationViewOfKind: WhiteBackgroundView.identifier)
        // 상세 정보 리스트의 배경뷰
        layout.register(DescriptionBackgroundView.self, forDecorationViewOfKind: DescriptionBackgroundView.identifier)
        return layout
    }
}

// MARK: - Bind
extension DictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.dictButton.rx.tap
            .map { Reactor.Action.dictionaryButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.reportButton.rx.tap
            .map { Reactor.Action.reportButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.menus)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                self?.mainView.detailCollectionView.reloadData()
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension DictionaryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        switch section {
        case 0:
            return 1
        case 1:
            return reactor.currentState.tags.count
        default:
            return reactor.currentState.menus.infos.count
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictionaryDetailMainCell.identifier, for: indexPath) as? DictionaryDetailMainCell,
                  let reactor = reactor else { return UICollectionViewCell() }
            cell.inject(input: DictionaryDetailMainCell.Input(image: .checkmark, backgroundColor: reactor.currentState.type.backgroundColor, name: reactor.currentState.name, subText: "Lv. 21", tags: reactor.currentState.tags, isBookmarked: false, onBookmarkTapped: {
                // 북마크 동작 필요
            }))
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BadgeCell.identifier, for: indexPath) as? BadgeCell,
                  let tags = reactor?.currentState.tags else { return UICollectionViewCell() }
            cell.inject(name: tags[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictionaryDetailDescriptionCell.identifier, for: indexPath) as? DictionaryDetailDescriptionCell,
                  let item = reactor?.currentState.menus.infos[indexPath.row]
            else { return UICollectionViewCell()
            }
            cell.inject(input: DictionaryDetailDescriptionCell.Input(mainText: item.name, clickableMainText: nil, additionalText: nil, subText: item.desc, clickableSubText: nil))
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DictionaryDetailHeaderView.identifier, for: indexPath) as? DictionaryDetailHeaderView,
              let reactor = reactor else { return UICollectionReusableView() }
        // 3번 섹션인 description 섹션에서만 header를 return
        if indexPath.section == 2 {
            view.inject(titles: reactor.currentState.type.detailTypes)
            view.bind(reactor: reactor)
        }
        return view
    }
    
    /// 스크롤에 따라 mainView.titleLabel의 text를 바꿔주기 위한 함수
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView,
              let reactor = reactor else { return }

        // 첫번째 섹션이 기준
        if let attr = collectionView.layoutAttributesForItem(at: IndexPath(item: 0, section: 1)) {
            let cellTopY = attr.frame.minY
            let offsetY = scrollView.contentOffset.y + collectionView.adjustedContentInset.top

            // 첫번째 섹션의 맨하단 or 두번째 섹션의 제일 상단을 기점으로 변경
            if offsetY >= cellTopY {
                mainView.titleLabel.attributedText = .makeStyledString(font: .sub_m_b, text: "\(reactor.currentState.name)")
            } else {
                mainView.titleLabel.attributedText = .makeStyledString(font: .sub_m_b, text: "몬스터 상세 정보")
            }
        }
    }
}
