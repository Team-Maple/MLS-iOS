import UIKit

import BaseFeature
import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit

final class ItemDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = ItemDictionaryDetailReactor

    // MARK: - Components
    private let detailInfoView = DetailStackInfoView(type: .item)
    private let monsterCardView = DetailStackCardView()
    private let sortedFactory: SortedBottomSheetFactory = SortedBottomSheetFactoryImpl()

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
private extension ItemDictionaryDetailViewController {
    func setupMainInfo() {
        // 상세 정보(메인?)
        inject(input: DictionaryDetailBaseViewController.Input(
            imageUrl: reactor?.currentState.itemDetailInfo.imgUrl,
            backgroundColor: type.backgroundColor,
            name: reactor?.currentState.itemDetailInfo.nameKr ?? "이름 없음",
            subText: reactor?.currentState.itemDetailInfo.requiredStats?.level.map { "Lv. \($0)" } ?? "" // 착용 레벨이 존재하는 아이템일 경우 레벨 보여주기
        ))
    }

    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.itemDetailInfo

        contentViews.append(detailInfoView)
        // descriptionText
        detailInfoView.descriptionLabel.text = infos.descriptionText ?? ""

        detailInfoView.reset()
        if let npcPrice = infos.npcPrice {
            detailInfoView.addInfo(mainText: "상점판매가", subText: "\(npcPrice.formatted()) 메소")
        }

        if let availableJobs = infos.availableJobs {
            let jobNames = availableJobs.compactMap { $0.jobName }.joined(separator: ", ")
            if !jobNames.isEmpty {
                detailInfoView.addInfo(mainText: "직업", subText: jobNames)
            }
        }

        if let requiredStats = infos.requiredStats {
            if let level = requiredStats.level {
                detailInfoView.addInfo(mainText: "착용레벨", subText: "Lv. \(level)")
            }
            if let str = requiredStats.str {
                detailInfoView.addInfo(mainText: "필요 STR", subText: "\(str)")
            }
            if let dex = requiredStats.dex {
                detailInfoView.addInfo(mainText: "필요 DEX", subText: "\(dex)")
            }
            if let int = requiredStats.intelligence {
                detailInfoView.addInfo(mainText: "필요 INT", subText: "\(int)")
            }
            if let luk = requiredStats.luk {
                detailInfoView.addInfo(mainText: "필요 LUK", subText: "\(luk)")
            }
            if let pop = requiredStats.pop {
                detailInfoView.addInfo(mainText: "필요 POP", subText: "\(pop)")
            }
        }
        // 해당 스트링들을 상수 추출 하는게 좋을지..
        if let equipmentStats = infos.equipmentStats {
            let statMappings: [(title: String, stat: Stats?)] = [
                ("STR 증가", equipmentStats.str),
                ("DEX 증가", equipmentStats.dex),
                ("INT 증가", equipmentStats.intelligence),
                ("LUK 증가", equipmentStats.luk),
                ("HP 증가", equipmentStats.hp),
                ("MP 증가", equipmentStats.mp),
                ("물리공격력 증가", equipmentStats.weaponAttack),
                ("마법공격력 증가", equipmentStats.magicAttack),
                ("물리방어력 증가", equipmentStats.physicalDefense),
                ("마법방어력 증가", equipmentStats.magicDefense),
                ("명중률 증가", equipmentStats.accuracy),
                ("회피율 증가", equipmentStats.evasion),
                ("이동속도 증가", equipmentStats.speed),
                ("점프력 증가", equipmentStats.jump)
            ]

            for (title, stat) in statMappings {
                if let base = stat?.base {
                    let subText = formatStatText(base: base, min: stat?.min, max: stat?.max)
                    detailInfoView.addInfo(mainText: title, subText: subText)
                }
            }

            if let attackSpeed = equipmentStats.attackSpeed, let attackSpeedDetails = equipmentStats.attackSpeedDetails {
                detailInfoView.addInfo(mainText: "공격속도", subText: "\(attackSpeed.formatted()) (\(attackSpeedDetails))")
            }
        }

        if let scrollDetail = infos.scrollDetail {
            let scrollMappings: [(title: String, value: Int?)] = [
                ("STR 증가", scrollDetail.strChange),
                ("DEX 증가", scrollDetail.dexChange),
                ("INT 증가", scrollDetail.intelligenceChange),
                ("LUK 증가", scrollDetail.lukChange),
                ("HP 증가", scrollDetail.hpChange),
                ("MP 증가", scrollDetail.mpChange),
                ("물리공격력 증가", scrollDetail.weaponAttackChange),
                ("마법공격력 증가", scrollDetail.magicAttackChange),
                ("물리방어력 증가", scrollDetail.physicalDefenseChange),
                ("마법방어력 증가", scrollDetail.magicDefenseChange),
                ("명중률 증가", scrollDetail.accuracyChange),
                ("회피율 증가", scrollDetail.evasionChange),
                ("이동속도 증가", scrollDetail.speedChange),
                ("점프력 증가", scrollDetail.jumpChange)
            ]

            if let successRate = scrollDetail.successRatePercent {
                detailInfoView.addInfo(mainText: "성공 확률", subText: "\(successRate)%")
            }

            if let targetItem = scrollDetail.targetItemTypeText {
                detailInfoView.addInfo(mainText: "사용 가능 장비", subText: targetItem)
            }

            for (title, value) in scrollMappings {
                if let value = value {
                    let sign = value >= 0 ? "+" : ""
                    detailInfoView.addInfo(mainText: title, subText: "\(sign)\(value.formatted())")
                }
            }
        }
    }

    func setUpMonsterView() {
        guard let reactor = reactor,
              let detailType = reactor.currentState.type.detailTypes.first,
              let filter = detailType.sortFilter.first else { return }
        monsterCardView.initFilter(firstFilter: filter)
        let monsters = reactor.currentState.monsters
        monsterCardView.reset()

        contentViews.append(monsterCardView)
        if monsters.isEmpty {
            contentViews[1] = DetailEmptyView(type: .dropMonsterWithText)
        } else {
            contentViews[1] = monsterCardView
            for monster in monsters {
                monsterCardView.inject(input: DetailStackCardView.Input(type: .dropMonsterWithText, imageUrl: monster.imageUrl ?? "", mainText: monster.monsterName, additionalText: "\(monster.dropRate ?? 0)%")
                )
            }
        }
    }
}

// MARK: - Bind
extension ItemDictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindUserAction(reactor: reactor)
        bindViewState(reactor: reactor)
        bindReportButton(
            providerId: reactor.state.map { $0.itemDetailInfo.itemId },
            itemName: reactor.state.map { $0.itemDetailInfo.nameKr ?? "" }
        )
    }

    private func bindUserAction(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        monsterCardView.filterButton.rx.tap
            .map { Reactor.Action.filterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        monsterCardView.tap
            .map { Reactor.Action.dataTapped(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        reactor.state.map(\.itemDetailInfo)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, item in
                owner.setupMainInfo()
                owner.setUpInfoStackView()
                owner.mainView.setBookmark(isBookmarked: item.bookmarkId != nil)
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.monsters)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.setUpMonsterView()
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) } // 값이 바뀔때만 이벤트 받음
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case let .filter(type):
                    guard let option = type.detailTypes.first else { return }
                    let viewController = owner.sortedFactory.make(sortedOptions: option.sortFilter, selectedIndex: owner.selectedIndex) { index in
                        owner.selectedIndex = index
                        let selectedFilter = option.sortFilter[index]
                        owner.monsterCardView.selectFilter(selectedType: selectedFilter)
                        reactor.action.onNext(.selectFilter(selectedFilter))
                    }
                    owner.tabBarController?.presentModal(viewController, hideTabBar: true)
                case let .detail(id):
                    let viewController = owner.dictionaryDetailFactory.make(type: .monster, id: id, bookmarkRelay: owner.bookmarkRelay, loginRelay: owner.loginRelay)
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
                        imageUrl: item.imgUrl,
                        background: DictionaryItemType.item.backgroundColor
                    )
                    self?.bookmarkRelay?.accept((item.itemId, item.bookmarkId))
                case let .delete(item):
                    self?.presentDeleteSnackBar(
                        imageUrl: item.imgUrl,
                        background: DictionaryItemType.item.backgroundColor
                    )
                    self?.bookmarkRelay?.accept((item.itemId, item.bookmarkId))
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
}

private extension ItemDictionaryDetailViewController {
    func formatStatText(base: Int, min: Int?, max: Int?) -> String {
        if let min = min, let max = max {
            return "\(base.formatted()) [\(min.formatted())-\(max.formatted())]"
        } else {
            return "\(base)"
        }
    }
}
