import os
import UIKit

/// 캐시할 이미지와 추가 데이터를 저장하는 구조체
internal struct CacheData {
    let fileName: String
    let creationDate: Date
    let expirationDate: Date
    let fileSize: Int

    /// 초기화 메소드
    /// - Parameters:
    ///   - fileName: 재구성한 파일명
    ///   - creationDate: 만료일 계산을 위한 생성날짜
    ///   - expiration: 계산된 만료기간
    ///   - fileSize: 파일 크기
    init(fileName: String, creationDate: Date, expiration: TimeInterval, fileSize: Int) {
        self.fileName = fileName
        self.creationDate = creationDate
        self.expirationDate = creationDate.addingTimeInterval(expiration)
        self.fileSize = fileSize
    }

    var isExpired: Bool {
        return Date() > expirationDate
    }
}

internal final class DiskStorage {
    // 싱글톤 인스턴스
    static let shared = DiskStorage()

    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    // 우선순위 보장과 저장시 안정성을 위한 큐
    private let queue = DispatchQueue(label: "com.diskStorage", attributes: .concurrent)
    // fileName을 키로 캐시데이터 저장
    private var cacheDatas: [String: CacheData] = [:]
    private var totalCacheSize: Int = 0

    private init() {
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("시스템 손상")
        }
        self.cacheDirectory = cacheDirectory.appendingPathComponent("ImageCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        // 캐시저장소 로드
        loadCacheData()
        // 주기적으로 정리
        startCacheCleanup()
    }

    /// 캐싱된 이미지를 불러오는 메소드
    /// - Parameters:
    ///   - url: 이미지 주소
    ///   - completion: url에 해당하는 이미지를 return (없으면 nil)
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        queue.async { [weak self] in
            guard let self else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            let fileName = self.createFilePath(url: url)
            let fileURL = self.cacheDirectory.appendingPathComponent(fileName)

            // 기존 저장소 확인
            guard let cacheData = self.cacheDatas[fileName], !cacheData.isExpired else {
                self.cleanCache(key: fileName)
                DispatchQueue.main.async { completion(nil) }
                return
            }

            if self.fileManager.fileExists(atPath: fileURL.path),
               let imageData = try? Data(contentsOf: fileURL),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async { completion(image) }
            } else {
                // 파일이 손상된 경우에만 cleanCache 호출
                self.cleanCache(key: fileName)
                DispatchQueue.main.async { completion(nil) }
            }
        }
    }

    /// 이미지를 캐시에 저장하는 메소드
    /// - Parameters:
    ///   - image: 이미지
    ///   - url: 이미지 주소
    func saveImage(image: UIImage, url: URL) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self, let data = image.jpegData(compressionQuality: 0.8) else { return }

            let fileName = self.createFilePath(url: url)
            let fileURL = self.cacheDirectory.appendingPathComponent(fileName)

            if !self.fileManager.fileExists(atPath: fileURL.path) {
                do {
                    try data.write(to: fileURL)
                    let cacheData = CacheData(
                        fileName: fileName,
                        creationDate: Date(),
                        expiration: ImageLoader.shared.configure.diskCacheExpiration,
                        fileSize: data.count
                    )
                    self.cacheDatas[fileName] = cacheData
                    self.totalCacheSize += data.count
                    self.checkCache()
                } catch {
                    os_log("디스크 캐시 저장 실패")
                }
            }
        }
    }

    /// 충돌 방지를 위한 파일 이름 재구성 메소드
    /// - Parameter url: 이미지 주소
    /// - Returns: 변경된 파일명을 return
    private func createFilePath(url: URL) -> String {
        // ToBe: - 파일명 길이 확인
        url.absoluteString
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? url.lastPathComponent
    }

    /// 캐시저장소를 로드하는 메소드
    private func loadCacheData() {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }

            do {
                let files = try self.fileManager.contentsOfDirectory(at: self.cacheDirectory, includingPropertiesForKeys: [.creationDateKey, .fileSizeKey])
                for fileURL in files {
                    let fileName = fileURL.lastPathComponent
                    let attributes = try fileURL.resourceValues(forKeys: [.creationDateKey, .fileSizeKey])
                    let creationDate = attributes.creationDate ?? Date()
                    let fileSize = attributes.fileSize ?? 0

                    // 기본 만료 시간 적용
                    let cacheData = CacheData(
                        fileName: fileName,
                        creationDate: creationDate,
                        expiration: ImageLoader.shared.configure.diskCacheExpiration,
                        fileSize: fileSize
                    )
                    self.cacheDatas[fileName] = cacheData
                    self.totalCacheSize += fileSize
                }
            } catch {
                os_log("캐시 로드 실패")
            }
        }
    }

    /// 캐시 삭제를 위한 제약을 검사하는 메소드
    private func checkCache() {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }

            let config = ImageLoader.shared.configure

            /// 만료된 캐시 제거
            self.cacheDatas.forEach { key, data in
                if data.isExpired {
                    self.cleanCache(key: key)
                }
            }

            /// 개수 제한
            while self.cacheDatas.count > config.diskCacheCountLimit {
                if let oldest = self.cacheDatas.min(by: { $0.value.creationDate < $1.value.creationDate }) {
                    self.cleanCache(key: oldest.key)
                }
            }

            /// 용량 제한
            while self.totalCacheSize > config.diskCacheSizeLimit {
                if let oldest = self.cacheDatas.min(by: { $0.value.creationDate < $1.value.creationDate }) {
                    self.cleanCache(key: oldest.key)
                }
            }
        }
    }

    /// 저장된 캐시를 제거하는 메소드
    private func cleanCache(key: String) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self, let cacheData = self.cacheDatas[key] else { return }
            let fileURL = self.cacheDirectory.appendingPathComponent(cacheData.fileName)
            try? self.fileManager.removeItem(at: fileURL)
            self.totalCacheSize -= cacheData.fileSize
            self.cacheDatas.removeValue(forKey: key)
        }
    }

    /// 주기적으로 캐시를 정리하는 메소드
    private func startCacheCleanup() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                self?.checkCache()
            }
            // 백그라운드에서 실행되는 타이머를 메인 루프에 추가
            RunLoop.current.add(timer, forMode: .common)
            // 백그라운드 스레드에서 타이머를 계속 실행하기 위해 RunLoop를 유지
            RunLoop.current.run()
        }
    }
}
