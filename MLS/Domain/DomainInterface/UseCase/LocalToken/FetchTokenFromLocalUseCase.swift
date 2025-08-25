import Foundation

public protocol FetchTokenFromLocalUseCase {
    /// 토큰을 가져오는 메서드
    /// - Parameter type: 가져오려는 토큰의 타입 (`accessToken` 또는 `refreshToken`)
    /// - Returns: 가져온 토큰을 담은 `Result<String, Error>`
    func execute(type: TokenType) -> Result<String, Error>
}
