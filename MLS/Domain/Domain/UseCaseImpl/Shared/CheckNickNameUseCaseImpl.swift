import Foundation

import DomainInterface

import RxSwift

public class CheckNickNameUseCaseImpl: CheckNickNameUseCase {
    public init() {}

    public func execute(nickName: String) -> Observable<Bool> {
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣ]{2,15}$"

        let trimmed = nickName.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = NSPredicate(format: "SELF MATCHES %@", pattern)
            .evaluate(with: trimmed)

        return .just(isValid)
    }
}
