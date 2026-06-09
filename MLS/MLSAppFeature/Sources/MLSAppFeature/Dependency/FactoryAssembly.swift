// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

import MLSAppFeatureInterface
import MLSAuthFeature
import MLSAuthFeatureInterface
import MLSBookmarkFeature
import MLSBookmarkFeatureInterface
import MLSCore
import MLSDictionaryFeature
import MLSDictionaryFeatureInterface
import MLSMyPageFeature
import MLSMyPageFeatureInterface
import MLSRecommendationFeature
import MLSRecommendationFeatureInterface

public enum FactoryAssembly {
    public static func register() {
        DIContainer.register(type: ItemFilterBottomSheetFactory.self) {
            ItemFilterBottomSheetFactoryImpl()
        }
        DIContainer.register(type: MonsterFilterBottomSheetFactory.self) {
            MonsterFilterBottomSheetFactoryImpl()
        }
        DIContainer.register(type: SortedBottomSheetFactory.self) {
            SortedBottomSheetFactoryImpl()
        }
        DIContainer.register(type: AddCollectionFactory.self) {
            AddCollectionFactoryImpl(
                collectionRepository: DIContainer.resolve(
                    type: CollectionRepository.self
                )
            )
        }
        DIContainer.register(type: BookmarkModalFactory.self) {
            BookmarkModalFactoryImpl(
                addCollectionFactory: DIContainer.resolve(
                    type: AddCollectionFactory.self
                ),
                collectionRepository: DIContainer.resolve(
                    type: CollectionRepository.self
                )
            )
        }
        DIContainer.register(type: LoginFactory.self) {
            LoginFactoryImpl(
                termsAgreementsFactory: DIContainer.resolve(
                    type: TermsAgreementFactory.self
                ),
                appleProvider: DIContainer.resolve(
                    type: SocialCredentialProvider.self, name: "apple"
                ),
                kakaoProvider: DIContainer.resolve(
                    type: SocialCredentialProvider.self, name: "kakao"
                ),
                socialLoginUseCase: DIContainer.resolve(
                    type: SocialLoginUseCase.self
                ),
                userDefaultsRepository: DIContainer.resolve(
                    type: UserDefaultsRepository.self, name: "authUserDefaultsRepository"
                )
            )
        }
        DIContainer.register(type: DictionaryDetailFactory.self) {
            DictionaryDetailFactoryImpl(
                loginFactory: {
                    DIContainer.resolve(type: LoginFactory.self)
                },
                bookmarkModalFactory: DIContainer.resolve(
                    type: BookmarkModalFactory.self
                ),
                detailOnBoardingFactory: DIContainer.resolve(
                    type: DetailOnBoardingFactory.self
                ),
                appCoordinator: {
                    DIContainer.resolve(type: AppCoordinatorProtocol.self)
                },
                dictionaryDetailAPIRepository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                ),
                bookmarkRepository: DIContainer
                    .resolve(type: BookmarkRepository.self),
                checkLoginUseCase: DIContainer.resolve(
                    type: CheckLoginUseCase.self
                ),
                fetchVisitDictionaryDetailUseCase: DIContainer.resolve(
                    type: FetchVisitDictionaryDetailUseCase.self
                )
            )
        }
        DIContainer.register(type: DictionaryMainListFactory.self) {
            DictionaryListFactoryImpl(
                checkLoginUseCase: DIContainer.resolve(
                    type: CheckLoginUseCase.self
                ),
                bookmarkRepository: DIContainer.resolve(
                    type: BookmarkRepository.self
                ),
                parseItemFilterResultUseCase: DIContainer.resolve(
                    type: ParseItemFilterResultUseCase.self
                ),
                dictionaryListAPIRepository: DIContainer.resolve(
                    type: DictionaryListAPIRepository.self
                ),
                itemFilterFactory: DIContainer.resolve(
                    type: ItemFilterBottomSheetFactory.self
                ),
                monsterFilterFactory: DIContainer.resolve(
                    type: MonsterFilterBottomSheetFactory.self
                ),
                sortedFactory: DIContainer.resolve(
                    type: SortedBottomSheetFactory.self
                ),
                bookmarkModalFactory: DIContainer.resolve(
                    type: BookmarkModalFactory.self
                ),
                detailFactory: DIContainer.resolve(
                    type: DictionaryDetailFactory.self
                )
            ) {
                DIContainer.resolve(type: LoginFactory.self)
            }
        }
        DIContainer.register(type: DictionarySearchResultFactory.self) {
            DictionarySearchResultFactoryImpl(
                dictionaryListAPIRepository: DIContainer.resolve(
                    type: DictionaryListAPIRepository.self
                ),
                recentSearchRepository: DIContainer.resolve(
                    type: RecentSearchRepository.self
                ),
                dictionaryMainListFactory: DIContainer.resolve(
                    type: DictionaryMainListFactory.self
                )
            )
        }
        DIContainer.register(type: DictionarySearchFactory.self) {
            DictionarySearchFactoryImpl(
                recentSearchRepository:
                    DIContainer
                    .resolve(type: RecentSearchRepository.self),
                searchResultFactory:
                    DIContainer
                    .resolve(type: DictionarySearchResultFactory.self)
            )
        }
        DIContainer.register(type: NotificationSettingFactory.self) {
            NotificationSettingFactoryImpl(
                notificationRepository: DIContainer.resolve(
                    type: NotificationPermissionRepository.self
                ),
                authRepository: DIContainer.resolve(
                    type: AuthAPIRepository.self
                )
            )
        }
        DIContainer.register(type: DictionaryNotificationFactory.self) {
            DictionaryNotificationFactoryImpl(
                notificationSettingFactory:
                    DIContainer
                    .resolve(
                        type: NotificationSettingFactory.self
                    ),
                fetchProfileUseCase:
                    DIContainer
                    .resolve(type: FetchProfileUseCase.self),
                checkNotificationPermissionUseCase:
                    DIContainer
                    .resolve(type: CheckNotificationPermissionUseCase.self),
                alarmRepository:
                    DIContainer
                    .resolve(type: AlarmRepository.self)
            )
        }
        DIContainer.register(type: DictionaryMainViewFactory.self) {
            DictionaryMainViewFactoryImpl(
                dictionaryMainListFactory: DIContainer.resolve(
                    type: DictionaryMainListFactory.self
                ),
                searchFactory: DIContainer.resolve(
                    type: DictionarySearchFactory.self
                ),
                notificationFactory: DIContainer.resolve(
                    type: DictionaryNotificationFactory.self
                ),
                loginFactory: DIContainer.resolve(type: LoginFactory.self),
                fetchProfileUseCase: DIContainer.resolve(
                    type: FetchProfileUseCase.self
                )
            )
        }
        DIContainer.register(type: OnBoardingNotificationSheetFactory.self) {
            OnBoardingNotificationSheetFactoryImpl(
                authRepository: DIContainer.resolve(
                    type: AuthAPIRepository.self
                ),
                appCoordinator: {
                    DIContainer.resolve(
                        type: AppCoordinatorProtocol.self
                    )
                }
            )
        }
        DIContainer.register(type: OnBoardingInputFactory.self) {
            OnBoardingInputFactoryImpl(
                checkEmptyUseCase: DIContainer.resolve(
                    type: CheckEmptyLevelAndRoleUseCase.self
                ),
                checkValidLevelUseCase: DIContainer.resolve(
                    type: CheckValidLevelUseCase.self
                ),
                authRepository:
                    DIContainer
                    .resolve(type: AuthAPIRepository.self),
                onBoardingNotificationFactory: DIContainer.resolve(
                    type: OnBoardingNotificationFactory.self
                ),
                appCoordinator: {
                    DIContainer.resolve(type: AppCoordinatorProtocol.self)
                }
            )
        }
        DIContainer.register(type: OnBoardingQuestionFactory.self) {
            OnBoardingQuestionFactoryImpl(
                onBoardingInputFactory: DIContainer.resolve(
                    type: OnBoardingInputFactory.self
                )
            )
        }
        DIContainer.register(type: TermsAgreementFactory.self) {
            TermsAgreementFactoryImpl(
                onBoardingQuestionFactory: DIContainer.resolve(
                    type: OnBoardingQuestionFactory.self
                ),
                socialSignUpUseCase:
                    DIContainer
                    .resolve(type: SocialSignUpUseCase.self),
                tokenRepository:
                    DIContainer
                    .resolve(type: TokenRepository.self)
            )
        }
        DIContainer.register(type: OnBoardingNotificationFactory.self) {
            OnBoardingNotificationFactoryImpl(
                onBoardingNotificationSheetFactory: DIContainer.resolve(
                    type: OnBoardingNotificationSheetFactory.self
                ),
                appCoordinator: {
                    DIContainer.resolve(
                        type: AppCoordinatorProtocol.self
                    )
                }
            )
        }
        DIContainer.register(type: BookmarkMainFactory.self) {
            BookmarkMainFactoryImpl(
                authRepository:
                    DIContainer
                    .resolve(type: BookmarkAuthRepository.self),
                userDefaultsRepository:
                    DIContainer
                    .resolve(type: BookmarkUserDefaultsRepository.self),
                onBoardingFactory:
                    DIContainer
                    .resolve(type: BookmarkOnBoardingFactory.self),
                bookmarkListFactory:
                    DIContainer
                    .resolve(type: BookmarkListFactory.self),
                collectionListFactory:
                    DIContainer
                    .resolve(type: CollectionListFactory.self),
                searchFactory:
                    DIContainer
                    .resolve(type: DictionarySearchFactory.self),
                notificationFactory: DIContainer.resolve(
                    type: DictionaryNotificationFactory.self
                ),
                loginFactory: DIContainer.resolve(type: LoginFactory.self)
            )
        }
        DIContainer.register(type: BookmarkOnBoardingFactory.self) {
            BookmarkOnBoardingFactoryImpl()
        }
        DIContainer.register(type: BookmarkListFactory.self) {
            BookmarkListFactoryImpl(
                itemFilterFactory: DIContainer.resolve(
                    type: ItemFilterBottomSheetFactory.self
                ),
                monsterFilterFactory: DIContainer.resolve(
                    type: MonsterFilterBottomSheetFactory.self
                ),
                sortedFactory: DIContainer.resolve(
                    type: SortedBottomSheetFactory.self
                ),
                bookmarkModalFactory: DIContainer.resolve(
                    type: BookmarkModalFactory.self
                ),
                loginFactory: DIContainer.resolve(type: LoginFactory.self),
                dictionaryDetailFactory: DIContainer.resolve(
                    type: DictionaryDetailFactory.self
                ),
                collectionEditFactory: DIContainer.resolve(
                    type: CollectionEditFactory.self
                ),
                authRepository: DIContainer
                    .resolve(type: BookmarkAuthRepository.self),
                bookmarkRepository: DIContainer
                    .resolve(type: BookmarkRepository.self),
                parseItemFilterResultUseCase: DIContainer.resolve(
                    type: ParseItemFilterResultUseCase.self
                )
            )
        }
        DIContainer.register(type: CollectionListFactory.self) {
            CollectionListFactoryImpl(
                collectionRepository: DIContainer.resolve(
                    type: CollectionRepository.self
                ),
                addCollectionFactory: DIContainer.resolve(
                    type: AddCollectionFactory.self
                ),
                collectionDetailFactory: DIContainer
                    .resolve(type: CollectionDetailFactory.self),
                sortedBottomSheetFactory:
                    DIContainer
                    .resolve(type: SortedBottomSheetFactory.self)
            )
        }
        DIContainer.register(type: CollectionDetailFactory.self) {
            CollectionDetailFactoryImpl(
                bookmarkModalFactory:
                    DIContainer
                    .resolve(type: BookmarkModalFactory.self),
                collectionSettingFactory:
                    DIContainer
                    .resolve(type: CollectionSettingFactory.self),
                addCollectionFactory:
                    DIContainer
                    .resolve(type: AddCollectionFactory.self),
                collectionEditFactory:
                    DIContainer
                    .resolve(type: CollectionEditFactory.self),
                dictionaryDetailFactory:
                    DIContainer
                    .resolve(type: DictionaryDetailFactory.self),
                collectionRepository: DIContainer
                    .resolve(type: CollectionRepository.self)
            )
        }
        DIContainer.register(type: CollectionSettingFactory.self) {
            CollectionSettingFactoryImpl()
        }
        DIContainer.register(type: CollectionEditFactory.self) {
            CollectionEditFactoryImpl(
                bookmarkModalFactory: DIContainer.resolve(
                    type: BookmarkModalFactory.self
                )
            )
        }
        DIContainer.register(type: MyPageMainFactory.self) {
            MyPageMainFactoryImpl(
                loginFactory: DIContainer.resolve(type: LoginFactory.self),
                setProfileFactory:
                    DIContainer
                    .resolve(type: SetProfileFactory.self),
                customerSupportFactory:
                    DIContainer
                    .resolve(type: CustomerSupportFactory.self),
                notificationSettingFactory:
                    DIContainer
                    .resolve(type: NotificationSettingFactory.self),
                setCharacterFactory:
                    DIContainer
                    .resolve(type: SetCharacterFactory.self),
                fetchProfileUseCase: DIContainer.resolve(
                    type: FetchProfileUseCase.self
                )
            )
        }
        DIContainer.register(type: CustomerSupportFactory.self) {
            CustomerSupportBaseViewFactoryImpl(
                policyFactory: DIContainer.resolve(
                    type: PolicyFactory.self
                ),
                alarmRepository: DIContainer.resolve(
                    type: AlarmRepository.self
                )
            )
        }
        DIContainer.register(type: SetProfileFactory.self) {
            SetProfileFactoryImpl(
                selectImageFactory: DIContainer.resolve(
                    type: SelectImageFactory.self
                ),
                checkNickNameUseCase: DIContainer.resolve(
                    type: CheckNickNameUseCase.self
                ),
                logoutUseCase: DIContainer.resolve(type: LogoutUseCase.self),
                withdrawUseCase: DIContainer.resolve(
                    type: WithdrawUseCase.self
                ),
                fetchProfileUseCase: DIContainer.resolve(
                    type: FetchProfileUseCase.self
                ),
                myPageRepository: DIContainer
                    .resolve(type: MyPageRepository.self)
            )
        }
        DIContainer.register(type: SetCharacterFactory.self) {
            SetCharacterFactoryImpl(
                checkEmptyUseCase:
                    DIContainer
                    .resolve(type: CheckEmptyLevelAndRoleUseCase.self),
                checkValidLevelUseCase:
                    DIContainer
                    .resolve(type: CheckValidLevelUseCase.self),
                authRepository: DIContainer
                    .resolve(type: AuthAPIRepository.self)
            )
        }
        DIContainer.register(type: SelectImageFactory.self) {
            SelectImageFactoryImpl(
                myPageRepository: DIContainer
                    .resolve(type: MyPageRepository.self)
            )
        }
        DIContainer.register(type: DetailOnBoardingFactory.self) {
            DetailOnBoardingFactoryImpl()
        }
        DIContainer.register(type: PolicyFactory.self) {
            PolicyFactoryImpl()
        }
        DIContainer.register(type: RecommendationMainFactory.self) {
            RecommendationMainFactoryImpl(
                repository: DIContainer.resolve(type: RecommendationRepository.self),
                makeLoginVC: {
                    DIContainer.resolve(type: LoginFactory.self).make(exitRoute: .pop)
                },
                makeCharacterSettingVC: {
                    DIContainer.resolve(type: SetCharacterFactory.self).make()
                }
            )
        }
    }
}
