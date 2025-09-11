import UIKit

import DesignSystem
import DomainInterface
import DictionaryFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

final class MapDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MapDictionaryDetailReactor

    //MARK: - Properties
    private var selectedIndex = 0
    
    // MARK: - Componenets
    private var mapInfoView: DetailStackMapView
    private var appearMonsterView = DetailStackCardView()
    private var appearNpcView = DetailStackCardView()
    private let sortedFactory: SortedBottomSheetFactory = SortedBottomSheetFactoryImpl()

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
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {
        appearMonsterView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in return reactor.pulse(\.$route) } // 값이 바뀔때만 이벤트 받음
            .withUnretained(self)
            .subscribe { (owner, route) in
                switch route {
                case .filter(let type):
                    let viewController = owner.sortedFactory.make(sortedOptions: type.detailSortedFilter, selectedIndex: owner.selectedIndex) { index in
                        owner.selectedIndex = index
                        let selectedFilter = reactor.currentState.type.detailSortedFilter[index]
                        owner.appearMonsterView.filterButton.setAttributedTitle(.makeStyledString(font: .btn_s_r, text: selectedFilter.rawValue, color: .textColor), for: .normal)
                        self.isBottomTabbarHidden = true
                    }
                    owner.tabBarController?.presentModal(viewController)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        
    }
}
