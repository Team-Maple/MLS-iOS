import Foundation

public struct JobListResponse {
    public var jobList: [Job]

    public init(jobList: [Job]) {
        self.jobList = jobList
    }
}

public struct Job: Equatable {
    public let name: String
    public let id: Int

    public init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}
