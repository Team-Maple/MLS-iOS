import DomainInterface

import RxSwift

public class UpdateNickNameUseCaseImpl: UpdateNickNameUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(nickName: String) -> Observable<MyPageResponse> {
        return repository.updateNickName(nickName: nickName)
    }
}
