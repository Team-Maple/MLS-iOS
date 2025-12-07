//
//public enum ViewType: Equatable {
//    case dictionary(ViewState)
//    case bookmark(ViewState)
//    
//    public enum ViewState {
//        case login(data: Bool)
//        case logout(data: Bool)
//    }
//    
//    var mainText: String? {
//        switch self {
//        case let .bookmark(state):
//            switch state {
//            case let .login(data):
//                return data ? nil : "아직 아무것도 없어요!"
//            case let .logout(data):
//                return "컬렉션은 로그인 후 이용 가능해요!"
//            }
//        case let .dictionary(state):
//            switch state {
//            case let .login(data):
//                return data ? nil : "검색 결과가 없어요"
//            case let .logout(data):
//                return data ? nil : "검색 결과가 없어요"
//            }
//        }
//    }
//    
//    var subText: String? {
//        switch self {
//        case let .bookmark(state):
//            switch state {
//            case let .login(data):
//                return data ? nil : "아직 아무것도 없어요!"
//            case let .logout(data):
//                return "자주 보는 정보, 검색 없이 바로 확인 할 수 있어요."
//            }
//        case .dictionary(_):
//            return nil
//        }
//    }
//    
//    var buttonText: String? {
//        switch self {
//        case let .bookmark(state):
//            switch state {
//            case let .login(data):
//                return data ? nil : "북마크하러 가기"
//            case let .logout(data):
//                return "로그인하러 가기"
//            }
//        case .dictionary(_):
//            return nil
//        }
//    }
//}
