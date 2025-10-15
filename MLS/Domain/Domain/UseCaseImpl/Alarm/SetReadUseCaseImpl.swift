import Foundation

import DomainInterface

import RxSwift

public class SetReadUseCaseImpl: SetReadUseCase {
    private var repository: AlarmAPIRepository

    public init(repository: AlarmAPIRepository) {
        self.repository = repository
    }

    public func execute(alarmLink: String) -> Completable {
        return repository.setRead(alarmLink: alarmLink)
    }
}
