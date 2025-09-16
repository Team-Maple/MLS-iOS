import UIKit

import BaseFeature
import DomainInterface

import ReactorKit
import RxSwift

final class NotificationSettingViewController: BaseViewController, View, UNUserNotificationCenterDelegate {
    
    public typealias Reactor = NotificationSettingReactor
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private var authorized: Bool?
    // MARK: - Components
    public var mainView = NotificationSettingView()

    public override init() {
        super.init()
    }
    /// 현재는 테스트 위해 허용 / 거부를 선택한 이후에 해당 값에 맞게 뷰나오도록 함
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self // NotificationCenter Delegate
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { [weak self] granted, _ in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.authorized = granted // 이거 반드시 필요
                self.makeNotificationView()
            }
        }

        isBottomTabbarHidden = true
        addViews()
        setupConstraints()
        bindBackButton()

        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.appWillEnterForeground()
            })
            .disposed(by: disposeBag)

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func appWillEnterForeground() {
        isNotificationOn { isOn in
            self.authorized = isOn
            DispatchQueue.main.async {
                self.makeNotificationView()
            }
        }
    }
}

// MARK: - SetUp
extension NotificationSettingViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension NotificationSettingViewController {
    func makeNotificationView() {
        guard let authorized = authorized else { return }
        mainView.clearNotificationViews()
        // 알림 권한 허용되지 않았을 경우
        if !authorized {
            mainView.onChangeButtonTapped = { [weak self] in
                guard let url = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            mainView.createNotificationView(titleText: "푸시 알림 설정", subText: "기기 설정을 변경해야 알림을 받을 수 있어요.", authorized: authorized)

        } else { // 알림 권한 허용되었을 경우
            mainView.createNotificationView(titleText: "신규 이벤트 알림 설정", subText: "메이플랜드 이벤트 소식을 푸시 알림으로 빠르게 받을 수 있어요.", authorized: authorized)
            mainView.createNotificationView(titleText: "공지사항 알림 설정", subText: "메이플랜드 공지사항을 푸시 알림으로 빠르게 받을 수 있어요.", authorized: authorized)
        }

    }
}

extension NotificationSettingViewController {
    func isNotificationOn(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional: // 알림 허용됨
                completion(true)
            case .denied, .ephemeral: // 알림 거부됨
                completion(false)
            case .notDetermined: // 아직 알림 권한 요청 안 함
                completion(false)
            @unknown default: // 알 수 없는 상태
                completion(false)
            }
        }
    }
}

// MARK: - Bind
extension NotificationSettingViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindUserActions(reactor: Reactor) {
        
    }
    
    private func bindState(reactor: Reactor) {
        
    }
    func bindBackButton() {
        mainView.backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
   
}
