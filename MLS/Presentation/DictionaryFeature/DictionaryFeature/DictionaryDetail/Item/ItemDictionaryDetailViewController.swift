import DesignSystem
import DomainInterface
import ReactorKit
import UIKit

final class ItemDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = ItemDictionaryDetailReactor

    // MARK: - Components
    private let detailInfoView = DetailStackInfoView()
    private let monsterCardView = DetailStackCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .item
        titleText = "아이템 상세정보"
        contentViews = [detailInfoView, monsterCardView]
        setupMainInfo()
        setUpInfoStackView()
        setUpCardStackView()
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
        
        for info in infos {
            detailInfoView.addInfo(mainText: info.name, subText: info.desc)
        }
    }

    func setUpCardStackView() {
        // 드롭 몬스터
        monsterCardView.inject(input: DetailStackCardView.Input(type: .dropMonsterWithText, imageUrl: "imageUrl", mainText: "여신 탑의 러스터픽시(보스 소환용)", subText: "Lv. 표시", additionalText: "0.001%"))
//        // 출현맵 - 몬스터
//        monsterCardView.inject(input: DetailStackCardView.Input(type: .appearMapWithText, imageUrl: "imageUrl", mainText: "사건의 지평선", subText: "카테고리", additionalText: "9마리"))
//        // 연계 퀘스트
//        monsterCardView.inject(input: DetailStackCardView.Input(type: .linkedQuest, imageUrl: "iamgeUrl", mainText: "퀘스트이름", subText: "수락 Lv. 21", questIndex: 0))
//        monsterCardView.inject(input: DetailStackCardView.Input(type: .linkedQuest, imageUrl: "iamgeUrl", mainText: "퀘스트이름", subText: "수락 Lv. 21", questIndex: 1))
//        monsterCardView.inject(input: DetailStackCardView.Input(type: .linkedQuest, imageUrl: "iamgeUrl", mainText: "퀘스트이름", subText: "수락 Lv. 21", questIndex: 2))
//        // 출현 NPC
//        monsterCardView.inject(input: DetailStackCardView.Input(type: .appearNPC, imageUrl: "iamgeUrl", mainText: "퀘스트이름"))
//        // 출현맵 - NPC
//        monsterCardView.inject(input: DetailStackCardView.Input(type: .appearMap, imageUrl: "imageUrl", mainText: "사건의 지평선", subText: "카테고리"))
//        // 퀘스트
//        monsterCardView.inject(input: DetailStackCardView.Input(type: .quest, imageUrl: "imageUrl", mainText: "퀘스트 이름", subText: "수락 Lv. 21"))
//        // 출현 몬스터
//        monsterCardView.inject(input: DetailStackCardView.Input(type: .appearMonsterWithText, imageUrl: "imageUrl", mainText: "여신 탑의 러스터픽시(보스 소환용)", subText: "Lv. 표시", additionalText: "9마리"))
//        // 드롭 아이템
//        monsterCardView.inject(input: DetailStackCardView.Input(type: .dropItemWithText, imageUrl: "imageUrl", mainText: "여신 탑의 러스터픽시(보스 소환용)", subText: "Lv. 표시", additionalText: "0.001%"))
    }
}

// MARK: - Bind
extension ItemDictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindUserAction(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindUserAction(reactor: Reactor) {}

    private func bindViewState(reactor: Reactor) {
        reactor.state
            .map(\.type.detailTypes)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] types in
                self?.setupMenu(types)
            })
            .disposed(by: disposeBag)
    }
}
