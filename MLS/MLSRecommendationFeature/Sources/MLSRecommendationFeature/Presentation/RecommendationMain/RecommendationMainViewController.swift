import UIKit

import MLSCore
import MLSDesignSystem
import MLSRecommendationFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class RecommendationMainViewController: BaseViewController, View {
    typealias Reactor = RecommendationMainReactor

    // MARK: - Properties
    var disposeBag = DisposeBag()
    var onLoginTapped: (() -> UIViewController?)?
    var onEditTapped: (() -> UIViewController?)?
    var onSearchTapped: (() -> UIViewController?)?
    var onNotificationTapped: (() -> UIViewController?)?
    var onDetailTapped: ((_ mapId: Int) -> UIViewController?)?
    var onBookmarkModalTapped: ((_ bookmarkIds: [Int], _ onComplete: ((Bool) -> Void)?) -> UIViewController)?

    private var mainView = RecommendationMainView()
}

// MARK: - Life Cycle
extension RecommendationMainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension RecommendationMainViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(CardListCell.self, forCellWithReuseIdentifier: CardListCell.identifier)
    }
}

// MARK: - Bind
extension RecommendationMainViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
        bindUIEvents(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.informationButton.rx.tap
            .map { Reactor.Action.informationButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.header.firstIconButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                guard let vc = owner.onSearchTapped?() else { return }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        mainView.header.secondIconButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                guard let vc = owner.onNotificationTapped?() else { return }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.emptyView.button.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                guard let vc = owner.onLoginTapped?() else { return }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        mainView.profileView.editButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                guard let vc = owner.onEditTapped?() else { return }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

    func bindProfile(reactor: Reactor) {
        let profileStream = reactor.state
            .observe(on: MainScheduler.instance)
            .compactMap { $0.profile }

        let jobNameStream = reactor.state
            .observe(on: MainScheduler.instance)
            .map { $0.jobName }

        Observable.combineLatest(profileStream, jobNameStream)
            .withUnretained(self)
            .subscribe { owner, pair in
                let (profile, jobName) = pair
                owner.mainView.profileView.configure(
                    imageURL: profile.profileImageUrl,
                    nickName: profile.nickname,
                    job: jobName,
                    level: profile.level ?? 0
                )
            }
            .disposed(by: disposeBag)
    }

    func bindUIEvents(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$uiEvent) }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, event in
                switch event {
                case .added(let map):
                    owner.presentAddSnackBar(map: map)
                case .deleted(let map):
                    owner.presentDeleteSnackBar(map: map)
                case .none:
                    break
                case .showAlert:
                    GuideAlertFactory.show(mainText: "레벨과 직업을 모두 입력하면\n맞춤 사냥터를 추천받을 수 있어요", ctaText: "입력하기", cancelText: "도감보러 가기", ctaAction: {
                        guard let vc = owner.onEditTapped?() else { return }
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }, cancelAction: {
                        if let tabBarController = owner.tabBarController as? BottomTabBarController {
                            tabBarController.selectTab(index: 0)
                        }
                    }, ctaRatio: 0.5)
                }
            })
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .observe(on: MainScheduler.instance)
            .map { $0.informationButtonIsOn }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, toolTipIsOn in
                if toolTipIsOn {
                    TooltipFactory.show(
                        text: "같은 레벨·직업 유저들이 자주 언급한 \n사냥터를 기반으로 추천해요.",
                        anchorView: owner.mainView.informationButton,
                        tooltipPosition: .topTrailing
                    )
                } else {
                    TooltipFactory.dismiss()
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .observe(on: MainScheduler.instance)
            .map { $0.isLogin }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, isLogin in
                owner.mainView.updateLoginState(isLogin: isLogin)
            }
            .disposed(by: disposeBag)

        bindProfile(reactor: reactor)

        reactor.state
            .observe(on: MainScheduler.instance)
            .map { $0.recommendations }
            .distinctUntilChanged { $0.map { ($0.mapId, $0.bookmarkId) }.elementsEqual($1.map { ($0.mapId, $0.bookmarkId) }) { $0 == $1 } }
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.mainView.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - SnackBar
private extension RecommendationMainViewController {
    func presentAddSnackBar(map: RecommendationMap) {
        ImageLoader.shared.loadImage(stringURL: map.iconUrl) { [weak self] image in
            guard let self, let image else { return }
            SnackBarFactory.createSnackBar(
                type: .normal,
                image: image,
                imageBackgroundColor: .clear,
                text: "사냥터를 북마크에 추가했어요.",
                buttonText: "컬렉션 추가",
                buttonAction: { [weak self] in
                    guard let self,
                          let bookmarkId = self.reactor?.currentState.recommendations
                          .first(where: { $0.mapId == map.mapId })?.bookmarkId else { return }
                    let vc = self.onBookmarkModalTapped?([bookmarkId]) { isAdd in
                        if isAdd {
                            ToastFactory.createToast(message: "컬렉션에 추가되었어요. 북마크 탭에서 확인 할 수 있어요.")
                        }
                    }
                    guard let vc else { return }
                    vc.modalPresentationStyle = .pageSheet
                    if let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium(), .large()]
                        sheet.prefersGrabberVisible = true
                        sheet.preferredCornerRadius = 16
                    }
                    self.present(vc, animated: true)
                }
            )
        }
    }

    func presentDeleteSnackBar(map: RecommendationMap) {
        ImageLoader.shared.loadImage(stringURL: map.iconUrl) { [weak self] image in
            guard let self, let image else { return }
            SnackBarFactory.createSnackBar(
                type: .delete,
                image: image,
                imageBackgroundColor: .clear,
                text: "사냥터를 북마크에서 삭제했어요.",
                buttonText: "되돌리기",
                buttonAction: { [weak self] in
                    self?.reactor?.action.onNext(.undoLastDeletedBookmark)
                }
            )
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RecommendationMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recommendations = reactor?.currentState.recommendations,
              indexPath.item < recommendations.count else { return }
        let map = recommendations[indexPath.item]
        guard let vc = onDetailTapped?(map.mapId) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactor?.currentState.recommendations.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardListCell.identifier, for: indexPath) as? CardListCell,
            let map = reactor?.currentState.recommendations[indexPath.item]
        else {
            return UICollectionViewCell()
        }

        cell.cardView.setMainText(text: map.nameKr)
        cell.cardView.setType(type: .recommended(rank: indexPath.row + 1))
        cell.cardView.isIconSelected = map.isBookmarked
        cell.cardView.onIconTapped = { [weak self] in
            self?.reactor?.action.onNext(.toggleBookmark(mapId: map.mapId))
        }

        ImageLoader.shared.loadImage(stringURL: map.iconUrl) { [weak self] image in
            guard let self, let image else { return }
            DispatchQueue.main.async {
                guard let currentCell = self.mainView.collectionView.cellForItem(at: indexPath) as? CardListCell else { return }
                currentCell.cardView.setImage(image: image, backgroundColor: .clear)
            }
        }

        return cell
    }
}
