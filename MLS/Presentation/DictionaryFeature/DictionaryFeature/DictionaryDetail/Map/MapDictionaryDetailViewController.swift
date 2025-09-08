import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class MapDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MapDictionaryDetailReactor

    // MARK: - Componenets
    private var mapInfoView: DetailStackMapView
    private var appearMonsterView = DetailStackCardView()
    private var appearNpcView = DetailStackCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainInfo()
        setUpMapView()
        setUpMonsterView()
        setUpNpcView()
        bindImageView()
    }

    init(imageUrl: String) {
        self.mapInfoView = DetailStackMapView(imageUrl: imageUrl)

        super.init(type: .map)
    }
}

// MARK: - SetUp
private extension MapDictionaryDetailViewController {
    func setUpMainInfo() {
        self.inject(
            input: DictionaryDetailBaseViewController
                .Input(
                    image: .add,
                    backgroundColor: type.backgroundColor,
                    name: "뇌전수리검",
                    subText: "Lv10"
                )
        )
    }
    
    func setUpMapView() {
        if true {
            contentViews.append(mapInfoView)
        } else {
            contentViews.append(DetailEmptyView(type: .mapInfo))
        }
    }
    
    func setUpMonsterView() {
        if true {
            contentViews.append(appearMonsterView)
            appearMonsterView
                .inject(
                    input: DetailStackCardView
                        .Input(
                            type: .appearMonsterWithText,
                            imageUrl: "testImage",
                            mainText: "여신 탑의 러스터 픽시(보스 소환용)",
                            subText: "Lv. 표시",
                            additionalText: "9마리"
                        )
                )
        } else {
            contentViews.append(DetailEmptyView(type: .appearMonsterWithText))
        }
    }
    
    func setUpNpcView() {
        if false {
            appearNpcView
                .inject(
                    input: DetailStackCardView
                        .Input(
                            type: .appearNPC,
                            imageUrl: "testImage",
                            mainText: "NPC 이름"
                        )
                )
        } else {
            contentViews.append(DetailEmptyView(type: .appearNPC))
        }
    }

    func bindImageView() {
        let tapGesture = UITapGestureRecognizer()
        mapInfoView.mapImageView.isUserInteractionEnabled = true
        mapInfoView.mapImageView.addGestureRecognizer(tapGesture)

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

    private func bindViewState(reactor: Reactor) {}
}
