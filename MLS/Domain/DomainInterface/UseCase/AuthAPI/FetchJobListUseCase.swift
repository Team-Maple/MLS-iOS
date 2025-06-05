import Foundation

import RxSwift

protocol FetchJobListUseCase {
    func execute() -> Observable<JobListResponse>
}
