import DomainInterface
import ReactorKit

open class MyPageReactor: Reactor {
    public var initialState: State = State(route: .none)
    
    public enum Route {
        case none // 초기 값
        
        case editProfile // 프로필 수정 페이지
        // MARK: - 설정 section
        case notificationSetting // 알림 설정 페이지
        case characterSetting  // 캐릭터 정보 설정 페이지
        // MARK: - 고객 지원 section
        case event // 메이플랜드 이벤트 페이지
        case notification // 메이플랜드 공지사항 페이지
        case patchNote // 메이플랜드 패치노트 페이지
        case policy // 정책 페이지
    }
    
    public enum Action {
        case editProfileButtonTapped // 프로필 수정 버튼 클릭
        
        case notificaitionSettingButtonTapped // 알림 설정 버튼 클릭
        case characterSettingButtonTapped // 캐릭터 정보 설정 버튼 클릭
        
        case eventButtonTapped // 이벤트 버튼 클릭
        case notificationButtonTapped // 공지사항 버튼 클릭
        case patchNoteButtonTapped // 패치노트 버튼 클릭
        case policyButtonTapped // 정책버튼 클릭
    }
    
    public enum Mutation {
        case navigateTo(Route)
    }
    
    public struct State {
        @Pulse var route: Route // 루트가 할당 되기만 하면 이벤트 방출
    }
    // 상태변경 명령 생성
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .editProfileButtonTapped:
            return .just(.navigateTo(.editProfile)) // 프로필 수정
        case .notificaitionSettingButtonTapped:
            return .just(.navigateTo(.notificationSetting)) // 알림 설정
        case .characterSettingButtonTapped:
            return .just(.navigateTo(.characterSetting)) // 캐릭터 정보 설정
            
        case .eventButtonTapped:
            return .just(.navigateTo(.event)) // 이벤트
        case .notificationButtonTapped:
            return .just(.navigateTo(.notification)) // 공지사항
        case .patchNoteButtonTapped:
            return .just(.navigateTo(.patchNote)) // 패치노트
        case .policyButtonTapped:
            return .just(.navigateTo(.policy)) // 정책
        }
    }
    // 상태변경
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .navigateTo(let route):
            newState.route = route // 뷰 루트 변경
        }
        return newState
    }
    
}
