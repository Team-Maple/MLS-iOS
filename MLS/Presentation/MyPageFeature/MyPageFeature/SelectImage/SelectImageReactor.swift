import DesignSystem
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class SelectImageReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case dismissWithSave
    }

    // MARK: - Reactor
    public enum Action {
        case cancelButtonTapped
        case applyButtonTapped
        case imageTapped(Int)
    }

    public enum Mutation {
        case navigateTo(route: Route)
        case selectImage(MapleIllustration)
    }

    public struct State {
        @Pulse var route: Route = .none
        var images: [MapleIllustration] = [
            .mushroom,
            .slime,
            .blueSnail,
            .juniorYeti,
            .yeti,
            .pepe,
            .wraith,
            .starPixie,
            .rash
        ]
        var selectedImage: MapleIllustration?
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    private let updateProfileImageUseCase: UpdateProfileImageUseCase

    // MARK: - init
    public init(updateProfileImageUseCase: UpdateProfileImageUseCase) {
        self.initialState = State()
        self.updateProfileImageUseCase = updateProfileImageUseCase
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cancelButtonTapped:
            return .just(.navigateTo(route: .dismiss))
        case .applyButtonTapped:
            guard let url = currentState.selectedImage?.url else { return .empty() }
            return updateProfileImageUseCase.execute(url: url)
                .andThen(.just(.navigateTo(route: .dismissWithSave)))
        case .imageTapped(let index):
            let image = currentState.images[index]
            return .just(.selectImage(image))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .selectImage(let image):
            newState.selectedImage = image
        }

        return newState
    }
}
