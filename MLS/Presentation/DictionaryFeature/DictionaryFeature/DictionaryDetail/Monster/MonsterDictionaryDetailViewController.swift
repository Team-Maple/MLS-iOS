import DesignSystem
import DomainInterface
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class MonsterDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MonsterDictionaryDetailReactor

    // MARK: - Componenets
    private var detailView = DetailStackInfoView(type: .monster)
    private var appearMapView = DetailStackMapView(imageUrl: "")
    private var dropItemView = DetailStackCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .monster
        setUpMainInfo()
        setUpInfoStackView()
        setUpMapView()
        setUpDropItemView()
    }
}

// MARK: - Populate Data
private extension MonsterDictionaryDetailViewController {
    func setUpMainInfo() {
        // 상세정보
        self.inject(
            input: DictionaryDetailBaseViewController
                .Input(
                    image: DesignSystemAsset.image(named: "testImage"),
                    backgroundColor: type.backgroundColor,
                    name: "다크 주니어 예티와 페페",
                    subText: "Lv21"
                )
        )
    }
    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.menus.infos

        if !infos.isEmpty {
            contentViews.append(detailView)
            for info in infos {
                detailView.addInfo(mainText: info.name, subText: info.desc)
            }
        } else {
            contentViews.append(DetailEmptyView(type: .normal))
        }
    }
    
    func setUpMapView() {
        if true {
            // 드롭아이템
            contentViews.append(appearMapView)
            dropItemView
                .inject(
                    input: DetailStackCardView
                        .Input(
                            type: .appearMapWithText,
                            imageUrl: "imageUrl",
                            mainText: "뇌전수리검",
                            subText: "Lv.21",
                            additionalText: "0.001%"
                        )
                )
        } else {
            contentViews.append(DetailEmptyView(type: .appearMapWithText))
        }
    }

    func setUpDropItemView() {
        if true {
            // 드롭아이템
            contentViews.append(dropItemView)
            dropItemView
                .inject(
                    input: DetailStackCardView
                        .Input(
                            type: .dropItemWithText,
                            imageUrl: "imageUrl",
                            mainText: "뇌전수리검",
                            subText: "Lv.21",
                            additionalText: "0.001%"
                        )
                )
        } else {
            contentViews.append(DetailEmptyView(type: .dropItemWithText))
        }
    }
}

// MARK: - Bind
extension MonsterDictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindcUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindcUserActions(reactor: Reactor) {

    }

    private func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.tags)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] tags in
                self?.makeTagsRow(tags)
            })
            .disposed(by: disposeBag)
    }
}
