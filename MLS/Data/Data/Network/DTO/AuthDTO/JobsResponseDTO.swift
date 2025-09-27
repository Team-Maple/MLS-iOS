import DomainInterface

public struct JobsDTO: Decodable {
    public let jobId: Int
    public let jobName: String
    public let jobLevel: Int
    public let parentJobId: Int?
}

public extension Array where Element == JobsDTO {
    func toDomain() -> JobListResponse {
        return JobListResponse(jobList: self.map { $0.jobName })
    }
}
