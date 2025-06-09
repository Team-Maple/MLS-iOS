import Foundation
import os
import Security

import DomainInterface

import RxSwift

public final class KeyChainRepositoryImpl: TokenRepository {
    // KeyChain 서비스 이름
    private let service = "keyChain"

    public init() { }

    public func fetchToken(type: TokenType) -> Result<String, Error> {
        // 1. query 작성
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: self.service,
            kSecAttrAccount: type.rawValue,
            kSecReturnData: true,  // CFData 타입으로 불러오라는 의미
            kSecMatchLimit: kSecMatchLimitOne // 중복되는 경우 하나의 값만 가져오라는 의미
        ]

        // 2. Read
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)

        // 3. Result
        if status == errSecItemNotFound {
            return .failure(TokenRepositoryError.noValueFound(message: "No value found for the specified key."))
        } else if status != errSecSuccess {
            return .failure(TokenRepositoryError.unhandledError(status: status))
        } else {
            if let data = dataTypeRef as? Data {
                if let value = String(data: data, encoding: .utf8) {
                    os_log("Successfully fetched \(type.rawValue) from KeyChain")
                    return .success(value)
                } else {
                    return .failure(TokenRepositoryError.dataConversionError(message: "Failed to convert data to String."))
                }
            } else {
                return .failure(TokenRepositoryError.dataConversionError(message: "Failed to convert data to Data type."))
            }
        }
    }

    public func saveToken(type: TokenType, value: String) -> Result<Void, Error> {
        // allowLossyConversion은 인코딩 과정에서 손실이 되는 것을 허용할 것인지 설정
        guard let convertValue = value.data(using: .utf8, allowLossyConversion: false) else {
            return .failure(TokenRepositoryError.dataConversionError(message: "Failed to convert value to Data."))
        }

        // 1. query 작성
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: self.service,
            kSecAttrAccount: type.rawValue,
            kSecValueData: convertValue
        ]

        // 2. Delete
        // KeyChain은 Key값에 중복이 생기면 저장할 수 없기 때문에 먼저 Delete
        SecItemDelete(keyChainQuery)

        // 3. Create
        let status = SecItemAdd(keyChainQuery, nil)
        if status == errSecSuccess {
            os_log("Successfully saved \(type.rawValue) from KeyChain: \(value)")
            return .success(())
        } else {
            return .failure(TokenRepositoryError.unhandledError(status: status))
        }
    }

    public func deleteToken(type: TokenType) -> Result<Void, Error> {
        // 1. query 작성
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: self.service,
            kSecAttrAccount: type.rawValue
        ]

        // 2. Delete
        let status = SecItemDelete(keyChainQuery)

        if status == errSecSuccess {
            os_log("Successfully deleted \(type.rawValue) from KeyChain")
            return .success(())
        } else {
            return .failure(TokenRepositoryError.unhandledError(status: status))
        }
    }
}
