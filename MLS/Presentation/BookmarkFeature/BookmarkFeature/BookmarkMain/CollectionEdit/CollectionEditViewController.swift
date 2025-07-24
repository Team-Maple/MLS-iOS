import UIKit

import BaseFeature
import BookmarkFeatureInterface

import ReactorKit
import RxSwift

public final class CollectionEditViewController: BaseViewController, View {
    public typealias Reactor = CollectionEditReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    private let bookmarkModalFactory: BookmarkModalFactory

    // MARK: - Components
    private var mainView = CollectionEditView()

    public init(bookmarkModalFactory: BookmarkModalFactory) {
        self.bookmarkModalFactory = bookmarkModalFactory
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
private extension CollectionEditViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
            .section { _ in layoutFactory.getCollectionListEditLayout() }
            .build()
        return layout
    }
}

// MARK: - Bind
extension CollectionEditViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.cancelButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.collection.items)
            .withUnretained(self)
            .subscribe { owner, collections in
                owner.mainView.listCollectionView.reloadData()
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .detail(let collection):
                    break
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
extension CollectionEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        cell.inject(input: DictionaryListCell.Input(type: item.type, mainText: item.mainText, subText: item.subText, image: item.image, isBookmarked: item.isBookmarked),  onBookmarkTapped: { [weak self] in
            guard let self = self else { return }
            if item.isBookmarked {
                self.reactor?.action.onNext(.toggleBookmark(item.id))
            } else {
                // 로그인 여부 확인
                if false {
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
                } else {
                    self.reactor?.action.onNext(.toggleBookmark(item.id))
                    SnackBarFactory.createSnackBar(type: .normal, image: item.image, imageBackgroundColor: item.type.backgroundColor, text: "아이템을 북마크에 추가했어요.", buttonText: "컬렉션 추가", buttonAction: {
                        DispatchQueue.main.async {
                            let viewController = self.bookmarkModalFactory.make { _ in
                                ToastFactory.createToast(message: "컬렉션에 추가되었어요. 북마크 탭에서 확인 할 수 있어요.")
                            }

                            viewController.modalPresentationStyle = .pageSheet

                            if let sheet = viewController.sheetPresentationController {
                                sheet.detents = [.medium(), .large()]
                                sheet.prefersGrabberVisible = true
                                sheet.preferredCornerRadius = 16
                            }

                            self.present(viewController, animated: true)
                        }
                    })
                }
            }
        })
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        reactor?.action.onNext(.itemTapped(indexPath.row))
    }
}
