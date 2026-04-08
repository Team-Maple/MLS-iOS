import RxSwift

public protocol CheckValidLevelUseCase {
    func execute(level: Int?) -> Observable<Bool?>
}
