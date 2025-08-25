import Foundation

public protocol SaveTokenToLocalUseCase {
    /// 토큰을 저장하는 메서드
    /// - Parameter type: 저장하려는 토큰의 타입 (`accessToken` 또는 `refreshToken`)
    /// - Parameter value: 저장할 토큰의 값
    /// - Returns: 완료 시 `Result<Void, Error>`
    func execute(type: TokenType, value: String) -> Result<Void, Error>
}
