import RxSwift

public protocol SetReadUseCase {
    func execute(alarmLink: String) -> Completable
}
