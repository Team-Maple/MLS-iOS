import DesignSystem
import DomainInterface
import ReactorKit
import UIKit

final class ItemDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = ItemDictionaryDetailReactor

    // MARK: - Components
    private let detailInfoView = DetailStackInfoView(type: .item)
    private let monsterCardView = DetailStackCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainInfo()
        setUpInfoStackView()
        setUpMonsterView()
    }
}

// MARK: - Populate Data
private extension ItemDictionaryDetailViewController {
    func setupMainInfo() {
        // 상세 정보(메인?)
        self.inject(input: DictionaryDetailBaseViewController.Input(
            image: DesignSystemAsset.image(named: "testImage2"),
            backgroundColor: type.backgroundColor,
            name: "뇌전수리검",
            subText: "Lv10"
        ))
    }
    
    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.itemInfos

        if !infos.isEmpty {
            contentViews.append(detailInfoView)
            for info in infos {
                detailInfoView.addInfo(mainText: info.name, subText: info.desc)
            }
        } else {
            contentViews.append(DetailEmptyView(type: .normal))
        }
    }

    func setUpMonsterView() {
        if true {
            contentViews.append(monsterCardView)
            monsterCardView
                .inject(
                    input: DetailStackCardView
                        .Input(
                            type: .dropMonsterWithText,
                            imageUrl: "imageUrl",
                            mainText: "여신 탑의 러스터픽시(보스 소환용)",
                            subText: "Lv. 표시",
                            additionalText: "0.001%"
                        )
                )
        } else {
            contentViews.append(DetailEmptyView(type: .dropMonsterWithText))
        }
    }
}

// MARK: - Bind
extension ItemDictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindUserAction(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindUserAction(reactor: Reactor) {}

    private func bindViewState(reactor: Reactor) {}
}
