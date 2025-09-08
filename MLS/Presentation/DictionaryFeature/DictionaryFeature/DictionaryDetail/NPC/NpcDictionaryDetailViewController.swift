import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class NpcDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = NpcDictionaryDetailReactor

    // MARK: - Componenets
    private var appearMapView = DetailStackCardView()
    private var questView = DetailStackCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        contentViews = [appearMapView, questView]
        setupMainInfo()
        setupCardStacckView()
    }

    init(imageUrl: String) {
        super.init(type: .npc)
    }
}

// MARK: - SetUp
private extension NpcDictionaryDetailViewController {
    func setupMainInfo() {
        // 상세정보(메인?)
        self.inject(input: DictionaryDetailBaseViewController.Input(image: .add, backgroundColor: type.backgroundColor, name: "뇌전수리검", subText: "Lv10"))
    }
    func setupCardStacckView() {
        // 드롭 아이템
        for i in 0...5 {
            appearMapView.inject(input: DetailStackCardView.Input(type: .appearMap, imageUrl: "testImage", mainText: "시간의 지평선", subText: "카테고리(커닝시티 등)"))
        }
        
        for i in 0...5 {
            questView.inject(input: DetailStackCardView.Input(type: .quest, imageUrl: "tesetImage", mainText: "퀘스트 이름", subText: "수락 Lv. 21"))
        }
    }
}

// MARK: - Bind
extension NpcDictionaryDetailViewController {
    func bind(reactor: Reactor) {
        bindcUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindcUserActions(reactor: Reactor) {}

    private func bindViewState(reactor: Reactor) {}
}
