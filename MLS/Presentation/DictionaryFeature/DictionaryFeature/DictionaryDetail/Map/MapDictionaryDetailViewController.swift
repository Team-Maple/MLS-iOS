import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class MapDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MapDictionaryDetailReactor

    // MARK: - Componenets
    var detailView: DetailStackMapView

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .map
        // title을 type 안으로 이동

        inject(input: DictionaryDetailBaseViewController.Input(image: .add, backgroundColor: type.backgroundColor, name: "뇌전수리검", subText: "Lv10"))
        addViews()
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
    func addViews() {
        mainView.secondSectionStackView.addArrangedSubview(detailView)
        mainView.secondSectionStackView.addArrangedSubview(detailView)
        mainView.secondSectionStackView.addArrangedSubview(detailView)
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
    public func bind(reactor: Reactor) {
        bindcUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindcUserActions(reactor: Reactor) {}

    func bindViewState(reactor: Reactor) {
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
