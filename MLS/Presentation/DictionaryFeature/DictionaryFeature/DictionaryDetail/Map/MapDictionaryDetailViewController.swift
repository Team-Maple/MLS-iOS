import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class MapDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MapDictionaryDetailReactor

    // MARK: - Componenets
    private var detailView: DetailStackMapView
    private var appearMapView = DetailStackMapView(imageUrl: "")
    private var dropItemView = DetailStackCardView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .map
        titleText = "맵 상세정보"
        contentViews = [detailView, appearMapView, dropItemView]
        setupMainInfo()
        setupCardStacckView()
        bindImageView()
    }

    init(reactor: MapDictionaryDetailReactor, imageUrl: String) {
        self.detailView = DetailStackMapView(imageUrl: imageUrl)

        super.init()
        self.reactor = reactor
    }
}

// MARK: - SetUp
private extension MapDictionaryDetailViewController {
    func setupMainInfo() {
        // 상세정보(메인?)
        self.inject(input: DictionaryDetailBaseViewController.Input(image: .add, backgroundColor: type.backgroundColor, name: "뇌전수리검", subText: "Lv10"))
    }
    func setupCardStacckView() {
        // 드롭 아이템
        dropItemView.inject(input: DetailStackCardView.Input(type: .dropItemWithText, imageUrl: "testImage", mainText: "일비표창", subText: "Lv.10", additionalText: "0.001%"))
    }
    
    func bindImageView() {
        let tapGesture = UITapGestureRecognizer()
        detailView.mapImageView.isUserInteractionEnabled = true
        detailView.mapImageView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
               .bind(onNext: { [weak self] _ in
                   guard let self else { return }
                   let viewController = PinchMapViewController(imageUrl: "")
                   viewController.modalPresentationStyle = .overFullScreen
                   self.present(viewController, animated: true)
               })
               .disposed(by: disposeBag)
    }
}

// MARK: - Bind
extension MapDictionaryDetailViewController {
    func bind(reactor: Reactor) {
        bindcUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindcUserActions(reactor: Reactor) {}

    private func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.type)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.titleText = "몬스터 상세정보"
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.type.detailTypes)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, types in
                owner.setupMenu(types)
            })
            .disposed(by: disposeBag)
    }
}
