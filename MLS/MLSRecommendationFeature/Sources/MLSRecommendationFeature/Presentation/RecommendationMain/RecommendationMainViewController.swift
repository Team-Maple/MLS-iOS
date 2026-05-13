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
    }

    func bindUserActions(reactor: Reactor) {
        mainView.informationButton.rx.tap
            .map { Reactor.Action.informationButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
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

        bindProfile(reactor: reactor)

        reactor.state
            .observe(on: MainScheduler.instance)
            .map { $0.recommendations }
            .distinctUntilChanged { $0.map(\.mapId) == $1.map(\.mapId) }
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.mainView.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RecommendationMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

        ImageLoader.shared.loadImage(stringURL: map.iconUrl) { image in
            guard let image else { return }
            DispatchQueue.main.async {
                cell.cardView.setImage(image: image, backgroundColor: .clear)
            }
        }

        return cell
    }
}
