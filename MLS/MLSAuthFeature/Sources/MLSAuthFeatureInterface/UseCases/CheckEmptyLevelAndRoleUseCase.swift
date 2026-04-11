public protocol CheckEmptyLevelAndRoleUseCase {
    func execute(level: Int?, job: String?) -> Bool
}
