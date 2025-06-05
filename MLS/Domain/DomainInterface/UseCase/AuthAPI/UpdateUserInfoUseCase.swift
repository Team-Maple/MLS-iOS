import Foundation

import RxSwift

protocol UpdateUserInfoUseCase {
    func execute(level: Int, selectedJob: String) -> Completable
}
