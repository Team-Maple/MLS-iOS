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

        inject(input: DictionaryDetailBaseViewController.Input(
            image: DesignSystemAsset.image(named: "testImage2"),
            backgroundColor: type.backgroundColor,
            name: "뇌전수리검",
            subText: "Lv10"
        ))

        addViews()
        setupConstraints()
        setUpInfoStackView()
        setUpCardStackView()
    }
}

// MARK: - Setup Views
private extension ItemDictionaryDetailViewController {
    func addViews() {
        mainView.secondSectionStackView.addArrangedSubview(detailInfoView)
        mainView.secondSectionStackView.addArrangedSubview(monsterCardView)
    }

    func setupConstraints() {
        detailInfoView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        monsterCardView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}

// MARK: - Populate Data
private extension ItemDictionaryDetailViewController {
    func setUpInfoStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.itemInfos

        for info in infos {
            detailInfoView.addInfo(mainText: info.name, subText: info.desc)
        }
    }

    func setUpCardStackView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.monsterInfos

        for info in infos {
            monsterCardView.addMonsterCard(
                name: info.name,
                level: info.level,
                dropRate: "0.001%",
                image: DesignSystemAsset.image(named: "testImage")!,
                backgroundColor: .listMonster
            )
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

    }

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
