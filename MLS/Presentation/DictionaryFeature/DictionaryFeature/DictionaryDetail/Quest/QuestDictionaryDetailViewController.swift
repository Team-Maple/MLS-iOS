import UIKit

import BaseFeature
import DesignSystem
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

final class QuestDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = QuestDictionaryDetailReactor
    // MARK: - Components
    private var detailInfoView = DetailStackInfoView(type: .quest)
    private var linkedQuestView = DetailStackCardView()

    override func toggleBookmark() {
        reactor?.action.onNext(.toggleBookmark)
    }

    override func checkLogin() -> Bool {
        guard let reactor = reactor else { return false }
        return reactor.currentState.isLogin
    }

    override func undoBookmark() {
        reactor?.action.onNext(.undoLastDeletedBookmark)
    }
}

// MARK: - Populate Data
private extension QuestDictionaryDetailViewController {
    func setUpMainInfo() {
        // 상세 정보(메인?)
        inject(input: DictionaryDetailBaseViewController.Input(
            imageUrl: reactor?.currentState.detailInfo.iconUrl,
            backgroundColor: type.backgroundColor,
            name: reactor?.currentState.detailInfo.nameKr ?? "이름 없음",
            subText: "수락 Lv.\(reactor?.currentState.detailInfo.minLevel ?? 0)"
        ))
    }

    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let detailInfos = reactor.currentState.detailInfo

        let rewardInfos = reactor.currentState.detailInfo.reward
        let rewardItemInfos = reactor.currentState.detailInfo.rewardItems

        contentViews.append(detailInfoView)
        // 뭘로 빈페이지 보여줄지 정하지..
        detailInfoView.reset()
        if !(detailInfos.startNpcName == nil) {
            contentViews.append(detailInfoView)
            // 완료조건 추가
            if let requirements = detailInfos.requirements {
                for requirement in requirements {
                    if let quantity = requirement.quantity {
                        if let name = requirement.itemName ?? requirement.monsterName,
                           let type = DictionaryType(rawValue: requirement.requirementType ?? "") {

                            if let id = type == .item ? requirement.itemId : requirement.monsterId {
                                detailInfoView.addCondition(
                                    mainText: name,
                                    subText: "\(quantity)",
                                    clickable: true,
                                    onTap: { [weak reactor] in
                                        reactor?.action.onNext(.infoTapped(type: type, id: id))
                                    }
                                )
                            } else {
                                detailInfoView.addCondition(
                                    mainText: name,
                                    subText: "\(quantity)",
                                    clickable: false,
                                    onTap: {}
                                )
                            }
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
                detailInfoView.addReward(mainText: DictionaryDetailText.meso, subText: "\(meso.formatted())")
            }
            if let exp = rewardInfos?.exp {
                detailInfoView.addReward(mainText: DictionaryDetailText.exp, subText: "\(exp.formatted())")
            }
            if let pop = rewardInfos?.popularity {
                detailInfoView.addReward(mainText: DictionaryDetailText.pop, subText: "\(pop.formatted())")
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
        let quests = reactor.currentState.totalQuest

        linkedQuestView.reset()
        contentViews.append(linkedQuestView)

        if quests.isEmpty {
            contentViews[1] = DetailEmptyView(type: .quest)
        } else {
            contentViews[1] = linkedQuestView

            for data in quests {
                linkedQuestView.inject(
                    input: DetailStackCardView.Input(
                        type: .linkedQuest,
                        imageUrl: data.quest.iconUrl ?? "",
                        mainText: data.quest.name,
                        subText: "수락 Lv.\(data.quest.minLevel ?? 0)",
                        questType: data.type
                    )
                )
            }
        }
    }
}

// MARK: - Bind
extension QuestDictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindUserAction(reactor: reactor)
        bindViewState(reactor: reactor)
        bindReportButton(providerId: reactor.state.map { $0.detailInfo.questId }, itemName: reactor.state.map { $0.detailInfo.nameKr ?? "" })
    }

    private func bindUserAction(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        linkedQuestView.tap
            .map { Reactor.Action.questTapped(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        reactor.state.map(\.detailInfo)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, map in
                owner.setUpMainInfo()
                owner.setUpInfoStackView()
                owner.mainView.setBookmark(isBookmarked: map.bookmarkId != nil)
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.totalQuest)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.setUpQuestView()
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case let .detail(type, id):
                    let viewController = owner.dictionaryDetailFactory.make(type: type, id: id, bookmarkRelay: owner.bookmarkRelay, loginRelay: owner.loginRelay)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .bookmarkError:
                    ToastFactory.createToast(message: "북마크 요청에 실패했어요. 다시 시도해주세요.")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$event)
            .bind(onNext: { [weak self] event in
                switch event {
                case let .add(item):
                    self?.presentAddSnackBar(
                        bookmarkId: item.bookmarkId,
                        imageUrl: item.iconUrl,
                        background: DictionaryItemType.item.backgroundColor
                    )
                    self?.bookmarkRelay?.accept((item.questId, item.bookmarkId))
                case let .delete(item):
                    self?.presentDeleteSnackBar(
                        imageUrl: item.iconUrl,
                        background: DictionaryItemType.item.backgroundColor
                    )
                    self?.bookmarkRelay?.accept((item.questId, item.bookmarkId))
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
}
