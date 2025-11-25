// swiftlint:disable line_length

import UIKit

import AuthFeatureInterface
import BaseFeature
import Core
import Data
import DataMock
import DesignSystem
import Domain
import DomainInterface
import MyPageFeature
import MyPageFeatureInterface

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ImageLoader.shared.configure.diskCacheCountLimit = 10
        FontManager.registerFonts()
        registerDependencies()

        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        print("알림 권한 요청 실패: \(error)")
                    } else {
                        print("알림 권한 허용 여부: \(granted)")
                    }
                }
            case .denied:
                print("사용자가 알림 권한 거부")
            case .authorized, .provisional, .ephemeral:
                print("알림 권한 이미 허용됨")
            @unknown default:
                break
            }
        }

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

private extension AppDelegate {
    func registerDependencies() {
        registerProvider()
        registerRepository()
        registerUseCase()
        registerFactory()
    }

    func registerProvider() {
        DIContainer.register(type: NetworkProvider.self) {
            NetworkProviderImpl()
        }
        DIContainer.register(type: Interceptor.self) {
            TokenInterceptor(fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self))
        }
    }

    func registerRepository() {
        DIContainer.register(type: TokenRepository.self) {
            KeyChainRepositoryImpl()
        }
        DIContainer.register(type: AuthAPIRepository.self) {
            AuthAPIRepositoryImpl(provider: DIContainer.resolve(type: NetworkProvider.self), interceptor: TokenInterceptor(fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self)))
        }
        DIContainer.register(type: AlarmAPIRepository.self) {
            AlarmAPIRepositoryImpl(provider: DIContainer.resolve(type: NetworkProvider.self), interceptor: DIContainer.resolve(type: Interceptor.self))
        }
    }

    func registerUseCase() {
        DIContainer.register(type: CheckNickNameUseCase.self) {
            CheckNickNameUseCaseImpl()
        }
        DIContainer.register(type: CheckEmptyLevelAndRoleUseCase.self) {
            CheckEmptyLevelAndRoleUseCaseImpl()
        }
        DIContainer.register(type: CheckValidLevelUseCase.self) {
            CheckValidLevelUseCaseImpl()
        }
        DIContainer.register(type: FetchJobListUseCase.self) {
            FetchJobListUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: UpdateUserInfoUseCase.self) {
            UpdateUserInfoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: UpdateNickNameUseCase.self) {
            UpdateNickNameUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: LogoutUseCase.self) {
            LogoutUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: WithdrawUseCase.self) {
            WithdrawUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self), tokenRepository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: FetchTokenFromLocalUseCase.self) {
            FetchTokenFromLocalUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: FetchNoticesUseCase.self) {
            FetchNoticesUseCaseImpl(repository: DIContainer.resolve(type: AlarmAPIRepository.self))
        }
        DIContainer.register(type: FetchOngoingEventsUseCase.self) {
            FetchOngoingEventsUseCaseImpl(repository: DIContainer.resolve(type: AlarmAPIRepository.self))
        }
        DIContainer.register(type: FetchOutdatedEventsUseCase.self) {
            FetchOutdatedEventsUseCaseImpl(repository: DIContainer.resolve(type: AlarmAPIRepository.self))
        }
        DIContainer.register(type: FetchPatchNotesUseCase.self) {
            FetchPatchNotesUseCaseImpl(repository: DIContainer.resolve(type: AlarmAPIRepository.self))
        }
        DIContainer.register(type: SetReadUseCase.self) {
            SetReadUseCaseImpl(repository: DIContainer.resolve(type: AlarmAPIRepository.self))
        }
        DIContainer.register(type: CheckNotificationPermissionUseCase.self) {
            CheckNotificationPermissionUseCaseImpl()
        }
        DIContainer.register(type: UpdateNotificationAgreementUseCase.self) {
            UpdateNotificationAgreementUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: UpdateProfileImageUseCase.self) {
            UpdateProfileImageUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: FetchJobUseCase.self) {
            FetchJobUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: FetchProfileUseCase.self) {
            FetchProfileUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self), fetchJobUseCase: DIContainer.resolve(type: FetchJobUseCase.self))
        }
    }

    func registerFactory() {
        DIContainer.register(type: SelectImageFactory.self) {
            SelectImageFactoryImpl(updateProfileImageUseCase: DIContainer.resolve(type: UpdateProfileImageUseCase.self))
        }

        DIContainer.register(type: SetProfileFactory.self) {
            SetProfileFactoryImpl(selectImageFactory: DIContainer.resolve(type: SelectImageFactory.self), checkNickNameUseCase: DIContainer.resolve(type: CheckNickNameUseCase.self), updateNickNameUseCase: DIContainer.resolve(type: UpdateNickNameUseCase.self), logoutUseCase: DIContainer.resolve(type: LogoutUseCase.self), withdrawUseCase: DIContainer.resolve(type: WithdrawUseCase.self))
        }

        DIContainer.register(type: SetCharacterFactory.self) {
            SetCharacterFactoryImpl(
                checkEmptyUseCase: DIContainer
                    .resolve(type: CheckEmptyLevelAndRoleUseCase.self),
                checkValidLevelUseCase: DIContainer
                    .resolve(type: CheckValidLevelUseCase.self),
                fetchJobListUseCase: DIContainer
                    .resolve(type: FetchJobListUseCase.self),
                updateUserInfoUseCase: DIContainer
                    .resolve(type: UpdateUserInfoUseCase.self)
            )
        }

        DIContainer.register(type: MyPageMainFactory.self) {
            MyPageMainFactoryImpl(
                loginFactory: DIContainer.resolve(type: LoginFactory.self), setProfileFactory: DIContainer
                    .resolve(type: SetProfileFactory.self),
                customerSupportFactory: DIContainer
                    .resolve(type: CustomerSupportFactory.self),
                notificationSettingFactory: DIContainer
                    .resolve(type: NotificationSettingFactory.self),
                setCharacterFactory: DIContainer
                    .resolve(type: SetCharacterFactory.self), fetchProfileUseCase: DIContainer.resolve(type: FetchProfileUseCase.self)
            )
        }

        DIContainer.register(type: CustomerSupportFactory.self) {
            CustomerSupportBaseViewFactoryImpl(fetchNoticesUseCase: DIContainer.resolve(type: FetchNoticesUseCase.self), fetchOngoingEventsUseCase: DIContainer.resolve(type: FetchOngoingEventsUseCase.self), fetchOutdatedEventsUseCase: DIContainer.resolve(type: FetchOutdatedEventsUseCase.self), fetchPatchNotesUseCase: DIContainer.resolve(type: FetchPatchNotesUseCase.self), setReadUseCase: DIContainer.resolve(type: SetReadUseCase.self))
        }

        DIContainer.register(type: NotificationSettingFactory.self) {
            NotificationSettingFactoryImpl(checkNotificationPermissionUseCase: DIContainer.resolve(type: CheckNotificationPermissionUseCase.self), updateNotificationAgreementUseCase: DIContainer.resolve(type: UpdateNotificationAgreementUseCase.self))
        }
        DIContainer.register(type: LoginFactory.self) {
            LoginFactoryMock()
        }
    }
}
