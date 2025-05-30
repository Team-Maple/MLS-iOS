import RxSwift

public protocol OnBoardingInputUseCase {
    func checkEmptyData(level: Int?, role: String?) -> Observable<Bool>
    func checkValidLevel(level: Int?) -> Observable<Bool?>
}
