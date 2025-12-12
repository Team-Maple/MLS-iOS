import RxSwift

public protocol FetchVisitDictionaryDetailUseCase {
    func execute() -> Observable<Bool>
}
