import Foundation
import Security

import RxSwift

public enum TokenRepositoryError: Error {
    case noValueFound(message: String) // 해당 키에 대해 값을 찾을 수 없을 때 발생
    case unhandledError(status: OSStatus) // 예상치 못한 OSStatus 오류가 발생했을 때 발생
    case dataConversionError(message: String) // 데이터 변환 중 오류가 발생했을 때 발생
}

public enum TokenType: String {
    case accessToken // 액세스 토큰
    case refreshToken // 리프레시 토큰
    case fcmToken // fcm토큰
}

public protocol TokenRepository {
    /// 토큰을 가져오는 메서드
    /// - Parameter type: 가져오려는 토큰의 타입 (`accessToken` 또는 `refreshToken`)
    /// - Returns: 가져온 토큰을 담은 `Single<String>`
    func fetchToken(type: TokenType) -> Result<String, Error>

    /// 토큰을 저장하는 메서드
    /// - Parameter type: 저장하려는 토큰의 타입 (`accessToken` 또는 `refreshToken`)
    /// - Parameter value: 저장할 토큰의 값
    /// - Returns: 완료 시 `Completable`
    func saveToken(type: TokenType, value: String) -> Result<Void, Error>

    /// 토큰을 삭제하는 메서드
    /// - Parameter type: 삭제하려는 토큰의 타입 (`accessToken` 또는 `refreshToken`)
    /// - Returns: 완료 시 `Completable`
    func deleteToken(type: TokenType) -> Result<Void, Error>
}
