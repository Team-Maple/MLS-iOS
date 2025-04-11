import UIKit

public enum ImageLoaderError: Error {
    case invalidURL
    case networkError(description: String?)
    case convertError(description: String?)
    case cacheNotFoundError
}

/// 이미지 로더 설정 클래스
public final class ImageLoaderConfigure {
    /// 메모리 캐시 만료 시간 (기본값 300초)
    var memoryCacheExpiration: TimeInterval = 300
    /// 메모리 캐시 갯수 제한 (기본값 100개)
    var memoryCacheCountLimit = 100 // 최대 100개까지 저장
    /// 메모리 코스트 제한 (최대 50MB까지 저장 기본 값 50MB)
    var memoryCacheTotalCostLimit = 50 * 1024 * 1024
}

/// URL을 통해 이미지를 비동기적으로 로드하는 클래스
public final class ImageLoader {
    
    static let shared = ImageLoader()
    
    /// 이미지 로더 설정 객체
    let configure = ImageLoaderConfigure()
    
    private init() {}
    
    /// URL을 통해 이미지를 로드하고, 실패 시 기본 이미지를 반환하는 메서드
    /// - Parameters:
    ///   - stringURL: 이미지 URL 문자열
    ///   - defaultImage: 로드 실패 시 반환할 기본 이미지
    ///   - completion: 로드 완료 후 호출되는 클로저
    func loadImage(url: URL?, defaultImage: UIImage?, completion: @escaping (UIImage?) -> Void) {
        loadImage(url: url) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure:
                completion(defaultImage)
            }
        }
    }
}

private extension ImageLoader {
    
    /// 네트워크 및 스토리지를 통해 이미지를 로드하는 내부 메서드
    /// - Parameters:
    ///   - stringURL: 이미지 URL 문자열
    ///   - completion: 로드 완료 후 호출되는 클로저
    func loadImage(url: URL?, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let url else {
            completion(.failure(ImageLoaderError.invalidURL))
            return
        }
        
        // 메모리 캐시에서 이미지 조회
        if let cachedImage = MemoryStorage.shared.fetchImage(stringURL: url.absoluteString) {
            completion(.success(cachedImage))
            return
        }
        
        // 네트워크 요청
        fetchDataFrom(url: url) { result in
            switch result {
            case .success(let data):
                if let data = data, let image = UIImage(data: data) {
                    MemoryStorage.shared.store(image: image, stringURL: url.absoluteString)
                    completion(.success(image))
                } else {
                    completion(.failure(ImageLoaderError.convertError(description: "Failed to convert data to UIImage")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// URL을 통해 데이터를 요청하는 메서드
    /// - Parameters:
    ///   - url: 요청할 URL 객체
    ///   - completion: 요청 완료 후 호출되는 클로저
    func fetchDataFrom(url: URL, completion: @escaping (Result<Data?, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(ImageLoaderError.networkError(description: "Network Error: \(error.localizedDescription)")))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
