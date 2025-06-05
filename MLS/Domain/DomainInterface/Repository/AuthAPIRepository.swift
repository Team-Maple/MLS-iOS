import Foundation

import RxSwift

protocol AuthAPIRepository {
    func getKakaoLogin() -> Observable<Bool>
}
