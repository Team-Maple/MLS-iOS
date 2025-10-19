import RxSwift

public protocol FetchJobUseCase {
    func execute(jobId: String) -> Observable<Job>
}
