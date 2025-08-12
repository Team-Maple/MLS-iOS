
import UIKit

import BaseFeature
import MypageFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class MyPageViewController: BaseViewController, View {
    
    private var mainView: MyPageView
    
    public typealias Reactor = MyPageReactor
    
    public var disposeBag = DisposeBag()
    
    private var buttonsDict: [ButtonType: UIButton] = [:]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        // 섹션 추가
        addSection(type: MyPageViewType.settings)
        addSection(type: MyPageViewType.customerSupport)
        self.reactor = MyPageReactor()
    }
    
    public override init() {
        self.mainView = MyPageView()
        super.init()
    }
    
    @available(*, unavailable)
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 섹션 추가
    func addSection(type: MyPageViewType) {
        // 섹션 속 수직 스택 뷰
        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .fill
        // 섹션 제목
        let titleLabel = UILabel()
        titleLabel.attributedText = .makeStyledString(font: .sub_m_b, text: type.title, color: .black)
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonStackView.addArrangedSubview(titleLabel)
        
        // 버튼들 추가
        for btnTitle in type.buttonTitle {
            let button = UIButton()
            button.setAttributedTitle(.makeStyledString(font: .b_m_r, text: btnTitle.rawValue, color: .init(hexCode: "#313131")), for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true

            buttonStackView.alignment = .leading
            buttonsDict[btnTitle] = button
            buttonStackView.addArrangedSubview(button)
        }
        
        buttonStackView.backgroundColor = .white
        buttonStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        buttonStackView.isLayoutMarginsRelativeArrangement = true
        buttonStackView.layer.cornerRadius = 16
        
        mainView.sectionStackView.addArrangedSubview(buttonStackView)
    }
}

// MARK: - Setup
private extension MyPageViewController {
    func addViews() { // Controller에 뷰 추가
        view.addSubview(mainView)
    }
    
    func setupConstraints() { // 제약 조건 설정
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind
public extension MyPageViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }
    // 액션과 리액터 바인드
    func bindUserActions(reactor: Reactor) {
        mainView.editProfileButton.rx.tap
            .map { Reactor.Action.editProfileButtonTapped}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        // 스택뷰 속 버튼들 마다 바인딩
        buttonsDict.forEach { (btnTitle, button) in
            switch btnTitle {
            case .notificationSetting:
                button.rx.tap.map { Reactor.Action.notificaitionSettingButtonTapped}
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
            case .characterSetting:
                button.rx.tap.map { Reactor.Action.characterSettingButtonTapped}
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
            case .event:
                button.rx.tap.map { Reactor.Action.eventButtonTapped}
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
            case .notification:
                button.rx.tap.map { Reactor.Action.notificationButtonTapped}
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
            case .patchNote:
                button.rx.tap.map { Reactor.Action.patchNoteButtonTapped}
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
            case .policy:
                button.rx.tap.map { Reactor.Action.policyButtonTapped}
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
            }
        }
        
    }
    // 상태와 뷰 바인드
    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .editProfile:
                    // 프로필 수정 뷰로 이동
                    let controller = UIViewController()
                    controller.view.backgroundColor = .brown
                    owner.navigationController?.pushViewController(controller, animated: true)
                    // 알림 설정 뷰로 이동
                case .notificationSetting:
                    let controller = UIViewController()
                    controller.view.backgroundColor = .orange
                    owner.navigationController?.pushViewController(controller, animated: true)
                    // 캐릭터 설정 뷰로 이동
                case .characterSetting:
                    let controller = UIViewController()
                    controller.view.backgroundColor = .blue
                    owner.navigationController?.pushViewController(controller, animated: true)
                    // 이벤트 뷰로 이동
                case .event:
                    let controller = UIViewController()
                    controller.view.backgroundColor = .red
                    owner.navigationController?.pushViewController(controller, animated: true)
                    // 공지사항 뷰로 이동
                case .notification:
                    let controller = UIViewController()
                    controller.view.backgroundColor = .green
                    owner.navigationController?.pushViewController(controller, animated: true)
                    // 패치노트 뷰로 이동
                case .patchNote:
                    let controller = UIViewController()
                    controller.view.backgroundColor = .black
                    owner.navigationController?.pushViewController(controller, animated: true)
                    // 정책 뷰로 이동
                case .policy:
                    let controller = UIViewController()
                    controller.view.backgroundColor = .purple
                    owner.navigationController?.pushViewController(controller, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
