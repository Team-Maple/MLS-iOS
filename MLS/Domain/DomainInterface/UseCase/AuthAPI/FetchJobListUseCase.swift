import Foundation

import RxSwift

public protocol FetchJobListUseCase {
    func execute() -> Observable<JobListResponse>
}
