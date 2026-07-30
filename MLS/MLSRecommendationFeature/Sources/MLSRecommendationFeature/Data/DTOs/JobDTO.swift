struct JobDTO: Decodable {
    let jobId: Int
    let jobName: String
    let jobLevel: Int
    let parentJobId: Int?
}
