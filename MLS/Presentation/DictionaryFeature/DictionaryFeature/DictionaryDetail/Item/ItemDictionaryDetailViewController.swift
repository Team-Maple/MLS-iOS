import DesignSystem
import DomainInterface
import ReactorKit
import UIKit

final class ItemDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = ItemDictionaryDetailReactor

    // MARK: - Propereties
    private var selectedIndex = 0 // 필터 선택 인덱스
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

    private func bindUserAction(reactor: Reactor) {
        monsterCardView.filterButton.rx.tap
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
                    // 추후 factory로 수정 필요
                    let bottomSheet = SortedBottomSheetViewController()
                    let bottomSheetReactor = SortedBottomSheetReactor(sortTypes: [.mostDrop, .levelLowest, .levelHighest], selectedIndex: owner.selectedIndex)
                    bottomSheet.reactor = bottomSheetReactor
                    bottomSheet.onSelectedIndex = { selectedIndex in
                        // TODO: reactor에 상태 추가해서 reactor의 상태 받아서 텍스트 변경해야 함
                        // TODO: 뷰에 필터버튼 텍스트 변경 함수도 따로 빼야함
                        self.monsterCardView.filterButton.setAttributedTitle(.makeStyledString(font: .btn_s_r, text: "\(bottomSheetReactor.currentState.sortTypes[selectedIndex].rawValue)", color: .textColor), for: .normal)
                        owner.selectedIndex = selectedIndex
                    }

                    if let sheet = bottomSheet.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.prefersGrabberVisible = true
                        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    }

                    owner.present(bottomSheet, animated: true)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

}
