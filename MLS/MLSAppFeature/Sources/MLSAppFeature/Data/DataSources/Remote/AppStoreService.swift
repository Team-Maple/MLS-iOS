import Foundation

import MLSAppFeatureInterface

/// iTunes Search API를 통해 앱스토어 버전 정보를 조회하는 Remote Data Source
final class AppStoreService {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    /// 앱스토어에서 최신 버전을 조회합니다
    /// - Parameter appID: 앱스토어 앱 ID
    /// - Returns: 최신 버전 정보
    /// - Throws: AppStoreError
    func fetchLatestVersion(appID: String) async throws -> Version {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appID)") else {
            throw AppStoreError.invalidURL
        }

        let (data, response) = try await urlSession.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AppStoreError.invalidResponse
        }

        guard let lookupResponse = try? JSONDecoder().decode(AppStoreLookupResponse.self, from: data) else {
            throw AppStoreError.parsingError
        }

        guard let result = lookupResponse.results.first,
              let version = Version(versionString: result.version) else {
            throw AppStoreError.versionNotFound
        }

        return version
    }
}

// MARK: - Response Models

private struct AppStoreLookupResponse: Decodable {
    let results: [AppStoreResult]
}

private struct AppStoreResult: Decodable {
    let version: String
}
