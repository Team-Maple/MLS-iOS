import RxSwift

public protocol UpdateProfileImageUseCase {
    func execute(url: String) -> Completable
}
