import Foundation

import RxSwift

public protocol UpdateUserInfoUseCase {
    func execute(level: Int, selectedJob: String) -> Completable
}
