import UIKit

import MLSCore
import MLSDesignSystem

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
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        mainView.profileView.configure(imageURL: nil, nickName: "익명의 판타지", job: "도적", level: 275)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(CardListCell.self, forCellWithReuseIdentifier: CardListCell.identifier)
    }
}

extension RecommendationMainViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
    }

    func bindViewState(reactor: Reactor) {
    }
}

extension RecommendationMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardListCell.identifier, for: indexPath) as? CardListCell else {
            return UICollectionViewCell()
        }
        cell.cardView.setMainText(text: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.")
        cell.cardView.setImage(image: UIImage(systemName: "person")!, backgroundColor: .green)
        cell.cardView.setType(type: .recommended(rank: 1))
        return cell
    }
}
