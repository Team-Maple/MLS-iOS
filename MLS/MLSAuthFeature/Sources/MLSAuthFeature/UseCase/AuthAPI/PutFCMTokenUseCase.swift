import RxSwift

public protocol PutFCMTokenUseCase {
    func execute(fcmToken: String?) -> Completable
}
