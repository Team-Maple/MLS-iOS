import DomainInterface

public struct JobsDTO: Decodable {
    public let jobId: Int
    public let jobName: String
    public let jobLevel: Int
    public let parentJobId: Int?
}

public extension JobsDTO {
    func toDomain() -> Job {
        return Job(name: jobName, id: jobId)
    }
}

public extension Array where Element == JobsDTO {
    func toDomain() -> JobListResponse {
        let jobs = self
            .filter { $0.jobLevel == 0 }
            .map { Job(name: $0.jobName, id: $0.jobId) }
        return JobListResponse(jobList: jobs)
    }
}
