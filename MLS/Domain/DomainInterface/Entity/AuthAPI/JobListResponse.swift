import Foundation

public struct JobListResponse {
    public var jobList: [String]

    public init(jobList: [String]) {
        self.jobList = jobList
    }
}
