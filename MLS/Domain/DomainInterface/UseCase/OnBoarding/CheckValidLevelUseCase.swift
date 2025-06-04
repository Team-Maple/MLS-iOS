import RxSwift

public protocol CheckValidLevelUseCase {
    func excute(level: Int?) -> Observable<Bool?>
}
