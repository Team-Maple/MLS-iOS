import UIKit

import DesignSystem
import DomainInterface

import ReactorKit

final class QuestDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = QuestDictionaryDetailReactor
    // MARK: - Components
    private var detailInfoView = DetailStackInfoView(type: .quest)
    private var linkedQuestView = DetailStackCardView()
}

// MARK: - Populate Data
private extension QuestDictionaryDetailViewController {
    func setUpMainInfo() {
        // 상세 정보(메인?)
        self.inject(input: DictionaryDetailBaseViewController.Input(
            imageUrl: reactor?.currentState.detailInfo.iconUrl,
            backgroundColor: type.backgroundColor,
            name: reactor?.currentState.detailInfo.nameKr ?? "이름 없음",
            subText: "Lv.\(reactor?.currentState.detailInfo.minLevel ?? 0)"
        ))
    }

    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let detailInfos = reactor.currentState.detailInfo
        
        let rewardInfos = reactor.currentState.detailInfo.reward
        let rewardItemInfos = reactor.currentState.detailInfo.rewardItems
        
        contentViews.append(detailInfoView)
        // 뭘로 빈페이지 보여줄지 정하지..
        if !(detailInfos.startNpcName == nil) {
            contentViews.append(detailInfoView)
            // 완료조건 추가
            if let requirements = detailInfos.requirements {
                for requirement in requirements {
                    if let quantity = requirement.quantity {
                        if let name = requirement.itemName ?? requirement.monsterName {
                            detailInfoView.addCondition(
                                mainText: name,
                                subText: "\(quantity)",
                                clickable: true,
                                onTap: { self.presentAlert() }
                            )
                        }
                    }
                }
            }
           
            if let minLevel = detailInfos.minLevel {
                detailInfoView.addDetailInfo(mainText: DictionaryDetailText.minLevel, subText: "\(minLevel)")
            }
            if let maxLevel = detailInfos.maxLevel {
                detailInfoView.addDetailInfo(mainText: DictionaryDetailText.maxLevel, subText: "\(maxLevel)")
            }
            if let startNpc = detailInfos.startNpcName {
                detailInfoView.addDetailInfo(mainText: DictionaryDetailText.startNpc, subText: startNpc)
            }
            if let endNpc = detailInfos.endNpcName {
                detailInfoView.addDetailInfo(mainText: DictionaryDetailText.endNpc, subText: endNpc)
            }
            if let jobs = detailInfos.allowedJobs {
                let jobNames = jobs.compactMap { $0.jobName } // nil 제거 + jobName만 추출
                let jobText = jobNames.joined(separator: ", ")
                if !jobText.isEmpty {
                    detailInfoView.addDetailInfo(mainText: DictionaryDetailText.job, subText: jobText)
                }
            }
            
            // 보상 추가 - 메소,경험치, 인기도
            if let meso = rewardInfos?.meso {
                detailInfoView.addReward(mainText: DictionaryDetailText.meso, subText: "\(meso)")
            }
            if let exp = rewardInfos?.exp {
                detailInfoView.addReward(mainText: DictionaryDetailText.exp, subText: "\(exp)")
            }
            if let pop = rewardInfos?.popularity {
                detailInfoView.addReward(mainText: DictionaryDetailText.pop, subText: "\(pop)")
            }
            if let rewardItems = rewardItemInfos {
                for info in rewardItems {
                    guard let name = info.itemName else { continue }
                    guard let quantity = info.quantity else { continue }
                    detailInfoView.addReward(mainText: name, subText: "\(quantity)")
                }
            }

        } else {
            contentViews.append(DetailEmptyView(type: .normal))
        }
    }

    func setUpQuestView() {
        guard let reactor = reactor else { return }
        let quests = reactor.currentState.linkedQuestInfo
        contentViews.append(linkedQuestView)
        if let previousQuests = quests.previousQuests, let nextQuests = quests.nextQuests {
            if previousQuests.isEmpty && nextQuests.isEmpty {
                contentViews[1] = DetailEmptyView(type: .quest)
            } else {
                contentViews[1] = linkedQuestView
                for quest in previousQuests + nextQuests {
                    linkedQuestView.inject(input: DetailStackCardView.Input(type: .linkedQuest, imageUrl: quest.iconUrl ?? "", mainText: quest.name, subText: "수락 Lv.\(quest.minLevel ?? 0)")
                    )
                }
            }
        }
        
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
        reactor.state.map(\.detailInfo)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.setUpMainInfo()
                self?.setUpInfoStackView()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.linkedQuestInfo)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] i in
                self?.setUpQuestView()
            })
            .disposed(by: disposeBag)
        
        rx.viewWillAppear.take(1).subscribe { _ in
            reactor.action.onNext(.viewWillAppear)
        }
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
