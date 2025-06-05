import Foundation

public struct JobListResponse {
    var jobList: [String]
    
    public init(jobList: [String]) {
        self.jobList = jobList
    }
}
