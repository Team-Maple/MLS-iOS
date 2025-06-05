import Foundation

public protocol DeleteTokenFromLocalUseCase {
    /// 토큰을 삭제하는 메서드
    /// - Parameter type: 삭제하려는 토큰의 타입 (`accessToken` 또는 `refreshToken`)
    /// - Returns: 완료 시 `Result<Void, Error>`
    func execute(type: TokenType) -> Result<Void, Error>
}
