import DomainInterface

import RxSwift

public class OnBoardingInputUseCaseImpl: OnBoardingInputUseCase {
    private let repository: OnBoardingInputRepository
    
    public init(repository: OnBoardingInputRepository) {
        self.repository = repository
    }
    
    public func checkEmptyData(level: Int?, role: String?) -> Observable<Bool> {
        return repository.checkEmptyData(level: level, role: role)
    }
    
    public func checkValidLevel(level: Int?) -> Observable<Bool?> {
        return repository.checkValidLevel(level: level)
    }
}
