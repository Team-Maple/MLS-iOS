import RxSwift

public protocol OnBoardingInputRepository {
    func checkEmptyData(level: Int?, role: String?) -> Observable<Bool>
    func checkValidLevel(level: Int?) -> Observable<Bool?>
}
