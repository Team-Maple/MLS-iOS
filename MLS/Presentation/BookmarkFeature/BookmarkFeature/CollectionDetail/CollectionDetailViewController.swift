import UIKit

import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class CollectionDetailViewController: BaseViewController, View {
    public var modalHeight: CGFloat?

    public typealias Reactor = CollectionDetailReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let bookmarkModalFactory: BookmarkModalFactory
    private let collectionSettingFactory: CollectionSettingFactory
    private let addCollectionFactory: AddCollectionFactory
    private let collectionEditFactory: CollectionEditFactory
    private let dictionaryDetailFactory: DictionaryDetailFactory

    private var selectedSortIndex = 0

    // MARK: - Components
    private var mainView: CollectionDetailView

    public init(reactor: CollectionDetailReactor, bookmarkModalFactory: BookmarkModalFactory, collectionSettingFactory: CollectionSettingFactory, addCollectionFactory: AddCollectionFactory, collectionEditFactory: CollectionEditFactory, dictionaryDetailFactory: DictionaryDetailFactory) {
        self.mainView = CollectionDetailView(navTitle: reactor.currentState.collection.title)
        self.bookmarkModalFactory = bookmarkModalFactory
        self.collectionSettingFactory = collectionSettingFactory
        self.addCollectionFactory = addCollectionFactory
        self.collectionEditFactory = collectionEditFactory
        self.dictionaryDetailFactory = dictionaryDetailFactory
        super.init()
        self.reactor = reactor
        navigationController?.navigationBar.isHidden = true
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
private extension CollectionDetailViewController {
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
            .section { _ in layoutFactory.getDictionaryListLayout() }
            .build()
        layout.register(Neutral300DividerView.self, forDecorationViewOfKind: Neutral300DividerView.identifier)
        return layout
    }
}

// MARK: - Bind
extension CollectionDetailViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.emptyView.bookmarkButton.rx.tap
            .map { Reactor.Action.bookmarkButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.navigation.leftButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.navigation.editButton.rx.tap
            .map { Reactor.Action.editButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.navigation.addButton.rx.tap
            .map { Reactor.Action.addButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.collection.items)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] items in
                self?.mainView.listCollectionView.reloadData()
                self?.mainView.isEmptyData(isEmpty: items.isEmpty)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$collectionMenu)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, menu in
                switch menu {
                case .editBookmark:
                    let viewController = owner.collectionEditFactory.make()
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .editName:
                    let viewController = owner.addCollectionFactory.make(collection: reactor.currentState.collection, onDismissWithMessage: { collection in
                        guard let collection = collection else { return }
                        reactor.action.onNext(.changeName(collection.title))
                    })
                    owner.present(viewController, animated: true)
                case .delete:
                    GuideAlertFactory.show(
                        mainText: "컬렉션을 삭제하시겠어요?",
                        ctaText: "삭제하기",
                        cancelText: "취소",
                        ctaAction: {
                            // 삭제 처리
                        },
                        cancelAction: {}
                    )
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .toMain:
                    owner.tabBarController?.selectedIndex = 0
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .edit:
                    let viewController = owner.collectionSettingFactory.make(setEditMenu: { menu in
                        owner.reactor?.action.onNext(.selectSetting(menu))
                    })
                    owner.presentModal(viewController)
                case .detail(let type,let id):
                    let viewController = owner.dictionaryDetailFactory.make(type: type, id: id)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension CollectionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reactor?.currentState.collection.items.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DictionaryListCell.identifier,
                for: indexPath
            ) as? DictionaryListCell,
            let item = reactor?.currentState.collection.items[indexPath.row]
        else {
            return UICollectionViewCell()
        }

//        cell.inject(
//            type: .bookmark,
//            input: DictionaryListCell.Input(
//                type: item.type,
//                mainText: item.mainText,
//                subText: item.subText,
//                image: item.image,
//                isSelected: item.isBookmarked
//            ),
//            onIconTapped: { [weak self] isSelcted in
//                guard let self = self else { return }
//                if item.isBookmarked {
//                    self.reactor?.action.onNext(.toggleBookmark(item.id, isSelcted))
//                } else {
//                    // 로그인 여부 확인
//                    if false {
//                        GuideAlertFactory.show(
//                            mainText: "북마크를 하려면 로그인이 필요해요.",
//                            ctaText: "로그인 하기",
//                            cancelText: "취소",
//                            ctaAction: {
//                                print("로그인 화면으로 이동")
//                            },
//                            cancelAction: {
//                                print("취소됨")
//                            }
//                        )
//                    } else {
//                        self.reactor?.action.onNext(.toggleBookmark(item.id, isSelcted))
//                        SnackBarFactory.createSnackBar(type: .normal, image: item.image, imageBackgroundColor: item.type.backgroundColor, text: "아이템을 북마크에 추가했어요.", buttonText: "컬렉션 추가", buttonAction: {
//                            DispatchQueue.main.async {
//                                let viewController = self.bookmarkModalFactory.make(onDismissWithColletions: { _ in }, onDismissWithMessage: { _ in
//                                    ToastFactory.createToast(message: "컬렉션에 추가되었어요. 북마크 탭에서 확인 할 수 있어요.")
//                                })
//
//                                viewController.modalPresentationStyle = .pageSheet
//
//                                if let sheet = viewController.sheetPresentationController {
//                                    sheet.detents = [.medium(), .large()]
//                                    sheet.prefersGrabberVisible = true
//                                    sheet.preferredCornerRadius = 16
//                                }
//
//                                self.present(viewController, animated: true)
//                            }
//                        })
//                    }
//                }
//            }
//        )

        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.dataTapped(indexPath.row))
    }
}
