import DesignSystem
import DomainInterface
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class MonsterDictionaryDetailViewController: DictionaryDetailBaseViewController, View {
    public typealias Reactor = MonsterDictionaryDetailReactor

    // MARK: - Componenets
    var detailView = MonsterDictionaryDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: - 리액터로 옮겨야 할 것들 많음.
        type = .monster
        inject(input: DictionaryDetailBaseViewController.Input(image: DesignSystemAsset.image(named: "testImage"), backgroundColor: type.backgroundColor, name: "다크 주니어 예티와 페페", subText: "Lv21"))
        addViews()
        setupConstraints()
        // 상세 설명 뷰 만들기
        makeDetailDescriptionTextView()
        // 출현 맵 뷰 만들기
        detailView.makeSpawnMapView()
    }
}

// MARK: - SetUp
private extension MonsterDictionaryDetailViewController {
    // 각 타입별 세그먼트 뷰 추가
    func addViews() {
        mainView.secondSectionStackView.addArrangedSubview(detailView.detailDescriptionStackView)
        mainView.secondSectionStackView.addArrangedSubview(detailView.detailMapStackView)
    }
    // 이것도 분리 가능할 듯
    // 아이템 쪽 작업하면서 생각해보기
    func setupConstraints() {
        detailView.detailDescriptionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(MonsterDictionaryDetailView.Constant.descriptionStackViewTopMargin)
            make.width.equalToSuperview().inset(MonsterDictionaryDetailView.Constant.descriptionStackViewHorizontalInset)
        }

        detailView.detailMapStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(MonsterDictionaryDetailView.Constant.descriptionStackViewTopMargin)
            make.width.equalToSuperview().inset(MonsterDictionaryDetailView.Constant.descriptionStackViewHorizontalInset)
        }
    }
}

private extension MonsterDictionaryDetailViewController {
    // 상세 설명에 맞는 텍스트 스택 뷰 생성 - (이름            설명)
    func makeDetailDescriptionTextView() {
        guard let reactor = reactor else { return }
        let infos = reactor.currentState.menus.infos

        for info in infos {
            let stackView = detailView.detailDescriptionTextViewSetup()
            // 동적 data에 의해 만들어지는 View -> 뷰컨에서 처리?
            let mainLabel = UILabel()
            mainLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: info.name)

            let subLabel = UILabel()
            subLabel.attributedText = .makeStyledString(font: .b_s_r, text: info.desc)

            stackView.addArrangedSubview(mainLabel)
            stackView.addArrangedSubview(subLabel)
        }
    }
}

// MARK: - Bind
extension MonsterDictionaryDetailViewController {
    public func bind(reactor: Reactor) {
        bindcUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindcUserActions(reactor: Reactor) {

    }

    func bindViewState(reactor: Reactor) {

        reactor.state
            .map(\.type)
            // UI 변경은 메인 스레드에서 하도록 (Rx에서 제공하는 문법인듯)
            // UI 업데이트 할 때는 쓰는게 안전하다고 함.
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] _ in
                self?.titleText = "몬스터 상세정보"
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.tags)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] tags in
                self?.makeTagsRow(tags)
            })
            .disposed(by: disposeBag)
        // 자식 타입의 메뉴탭 타입들
        reactor.state
            .map(\.type.detailTypes)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] types in
                /// detailTypes에 들어있는 모든 타입을 넘겨줌
                ///  [.normal, .appearMap, .dropItem]
                self?.setupMenu(types)
            })
            .disposed(by: disposeBag)
    }
}
