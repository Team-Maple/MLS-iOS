import UIKit

import DesignSystem
import DomainInterface
import ReactorKit

final class QuestDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = QuestDictionaryDetailReactor
    // MARK: - Components
    private var detailInfoView = DetailStackInfoView(type: .quest)
    private var linkedQuestView = DetailStackCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        type = .quest
        titleText = "퀘스트 상세정보"
        contentViews = [detailInfoView, linkedQuestView]
        setupMainInfo()
        setupInfoStackView()
        setupCardStackView()
    }
}

// MARK: - Populate Data
private extension QuestDictionaryDetailViewController {
    func setupMainInfo() {
        // 상세 정보(메인?)
        self.inject(input: DictionaryDetailBaseViewController.Input(
            image: DesignSystemAsset.image(named: "testImage2"),
            backgroundColor: type.backgroundColor,
            name: "슈미의 의뢰(넬라와 커닝시티 주민들의 의뢰)슈미의 의뢰(넬라와 커닝시티 주민들의 의뢰)슈미의 의뢰",
            subText: "Lv10"
        ))
    }

    func setupInfoStackView() {
        guard let reactor = reactor else { return }
        let completeConditionInfos = reactor.currentState.questConditionInfo
        let detailInfos = reactor.currentState.questDetailInfo
        let rewardInfos = reactor.currentState.questRewardInfo
        // 완료조건 추가
        for info in completeConditionInfos {
            detailInfoView.addCondition(mainText: info.name, subText: info.desc, clickable: info.clickable, onTap: { self.presentAlert() })

        }
        // 상세정보 추가
        for info in detailInfos {
            detailInfoView.addDetailInfo(mainText: info.name, subText: info.desc)
        }
        // 보상 추가
        for info in rewardInfos {
            detailInfoView.addReward(mainText: info.name, subText: info.desc)
        }
    }

    func setupCardStackView() {
        linkedQuestView.inject(input: DetailStackCardView.Input(type: .linkedQuest, imageUrl: "imageUrl", mainText: "퀘스트이름", subText: "수락 Lv.21", questIndex: 0))
    }
}

// MARK: - Bind
extension QuestDictionaryDetailViewController {
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

// MARK: - 임시Alert
extension QuestDictionaryDetailViewController {
    func presentAlert() {
        let alert = UIAlertController(title: "알림", message: "페이지 이동Alert", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            print("확인 버튼 클릭됨")
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
