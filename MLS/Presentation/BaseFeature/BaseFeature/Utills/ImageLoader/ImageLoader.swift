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
    public var memoryCacheExpiration: TimeInterval = 300
    /// 메모리 캐시 갯수 제한 (기본값 100개)
    public var memoryCacheCountLimit = 100 // 최대 100개까지 저장
    /// 메모리 코스트 제한 (최대 50MB까지 저장 기본 값 50MB)
    public var memoryCacheTotalCostLimit = 50 * 1024 * 1024
    /// 디스크 캐시 만료 시간 (기본값 일주일)
    public var diskCacheExpiration: TimeInterval = 7 * 24 * 60 * 60 // 7일
    /// 디스크 캐시 갯수 제한
    public var diskCacheCountLimit = 1000 // 최대 1000개 파일
    /// 디스크 캐시 용량 제한 (최대 500MB)
    public var diskCacheSizeLimit = 500 * 1024 * 1024 // 500MB
}

/// URL을 통해 이미지를 비동기적으로 로드하는 클래스
public final class ImageLoader {
    public static let shared = ImageLoader()

    /// 이미지 로더 설정 객체
    public let configure = ImageLoaderConfigure()

    private init() {}

    /// URL을 통해 이미지를 로드하고, 실패 시 기본 이미지를 반환하는 메서드
    /// - Parameters:
    ///   - stringURL: 이미지 URL 문자열
    ///   - defaultImage: 로드 실패 시 반환할 기본 이미지
    ///   - completion: 로드 완료 후 호출되는 클로저
    public func loadImage(url: URL?, defaultImage: UIImage?, completion: @escaping (UIImage?) -> Void) {
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

            // 디스크 캐시에서 이미지 조회
            DiskStorage.shared.fetchImage(url: url) { image in
                if let image {
                    // 디스크에서 가져온 이미지를 메모리캐시에 저장
                    MemoryStorage.shared.saveImage(image: image, stringURL: url.absoluteString)
                    completion(.success(image))
                } else {
                    // 메모리와 디스크 둘다 없다면 네트워크 요청
                    self.fetchDataFrom(url: url) { result in
                        switch result {
                        case .success(let data):
                            if let data {
                                // GIF인지 확인하고 처리
                                if let source = CGImageSourceCreateWithData(data as CFData, nil) {
                                    let frameCount = CGImageSourceGetCount(source)
                                    if frameCount > 1 {
                                        // GIF로 간주
                                        var images: [UIImage] = []
                                        var duration: TimeInterval = 0
                                        for index in 0..<frameCount {
                                            if let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) {
                                                let uiImage = UIImage(cgImage: cgImage)
                                                images.append(uiImage)
                                                // 프레임별 지연 시간 계산 (선택적)
                                                if let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any],
                                                   let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                                                   let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double {
                                                    duration += delayTime
                                                }
                                            }
                                        }
                                        if let animatedImage = UIImage.animatedImage(with: images, duration: duration > 0 ? duration : Double(frameCount) * 0.1) {
                                            MemoryStorage.shared.saveImage(image: animatedImage, stringURL: url.absoluteString)
                                            DiskStorage.shared.saveImage(image: animatedImage, url: url)
                                            completion(.success(animatedImage))
                                        }
                                    } else {
                                        // 정적 이미지
                                        if let image = UIImage(data: data) {
                                            MemoryStorage.shared.saveImage(image: image, stringURL: url.absoluteString)
                                            DiskStorage.shared.saveImage(image: image, url: url)
                                            completion(.success(image))
                                        } else {
                                            completion(.failure(ImageLoaderError.convertError(description: "Failed to convert data to UIImage")))
                                        }
                                    }
                                } else {
                                    completion(.failure(ImageLoaderError.convertError(description: "Failed to create image source")))
                                }
                            } else {
                                completion(.failure(ImageLoaderError.convertError(description: "No data received")))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            }
        }

    /// URL을 통해 데이터를 요청하는 메서드
    /// - Parameters:
    ///   - url: 요청할 URL 객체
    ///   - completion: 요청 완료 후 호출되는 클로저
    func fetchDataFrom(url: URL, completion: @escaping (Result<Data?, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(ImageLoaderError.networkError(description: "Network Error: \(error.localizedDescription)")))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
